const { PrismaClient } = require("@prisma/client");
const { handleError } = require("../../helpers");
const prisma = new PrismaClient();

const createMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const { content, newConversation } = req.body;

    let existingConversation;

    if (newConversation) {
      // If new conversation is specified in the body, create a new conversation for the user
      existingConversation = await prisma.conversationWithBot.create({
        data: {
          userId: userId,
        },
      });
    } else {
      // Otherwise, find the existing conversation for the user
      existingConversation = await prisma.conversationWithBot.findFirst({
        where: { userId: userId },
      });
    }

    const userMessage = await prisma.message.create({
      data: {
        content,
        sender: { connect: { id: userId } },
        conversation: { connect: { id: existingConversation.id } },
      },
    });

    const chatbotResponse = await prisma.response.create({
      data: {
        content: "Hello, I am MedCat!",
        sender: { connect: { id: userId } },
        message: { connect: { id: userMessage.id } },
      },
    });

    res.status(201).json({
      userMessage: {
        id: userMessage.id,
        content: userMessage.content,
        timestamp: userMessage.timestamp,
        sender: {
          id: userId,
        },
      },
      chatbotResponse: {
        id: chatbotResponse.id,
        content: chatbotResponse.content,
        timestamp: chatbotResponse.timestamp,
        sender: {
          id: userId,
        },
      },
    });
  } catch (e) {
    handleError(res, e, 'Error creating message');
  }
};

const getMessagesByConversationId = async (req, res) => {
  try {
    const userId = req.user.id;
    const  conversationId = req.params.id;

    const messages = await prisma.message.findMany({
      where: { senderId: userId, conversationId: parseInt(conversationId) },
      orderBy: { timestamp: 'asc' },
      include: {
        sender: { select: {id: true, firstName: true, lastName: true}},
        conversation: true,
        responses: true,
      },
    });

    res.status(200).json({ messages });
  } catch (e) {
    handleError(res, e, 'Error retrieving messages by conversation ID');
  }
};

const createResponse = async (req, res) => {
  try {
    const userId = req.user.id;
    const { content, conversationId } = req.body;
    // If conversation ID is not provided, find the last user message across all conversations
    let lastUserMessage;
    if (!conversationId) {
      lastUserMessage = await prisma.message.findFirst({
        where: { senderId: userId },
        orderBy: { timestamp: 'desc' },
      });
    } else {
      // Find the last user message in the specified conversation
      lastUserMessage = await prisma.message.findFirst({
        where: { senderId: userId, conversationId: conversationId },
        orderBy: { timestamp: 'desc' },
      });
    }

    if (!lastUserMessage) {
      return res.status(404).json({ error: 'No previous messages found for the user' });
    }

    const chatbotResponse = await prisma.response.create({
      data: {
        content,
        sender: { connect: { id: userId } },
        message: { connect: { id: lastUserMessage.id } },
      },
    });

    res.status(201).json({
      chatbotResponse: {
        id: chatbotResponse.id,
        content: chatbotResponse.content,
        timestamp: chatbotResponse.timestamp,
        sender: {
          id: userId,
        },
      },
    });
  } catch (e) {
    handleError(res, e, 'Error creating response');
  }
};

  module.exports = {
    createMessage,
    createResponse,
    getMessagesByConversationId,
  };
