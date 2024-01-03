const { PrismaClient } = require("@prisma/client");
const { handleError } = require("../../helpers");
const prisma = new PrismaClient();

const createContactProfessional = async (req, res) => {
  try {
    const senderId = req.user.id;
    const { recipientId, content } = req.body;
   
    const newContactProfessional = await prisma.contactProfessional.create({
        data: {
          conversation: {
            create: {
              sender: { connect: { id: senderId } },
              recipient: { connect: { id: recipientId } },
            },
          },
          sender: { connect: { id: senderId } },
          recipient: { connect: { id: recipientId } },
          content,
        },
        include: {
          sender: { select: { firstName: true, lastName: true } },
          recipient: { select: { user: { select: { firstName: true, lastName: true } } } },
        },
      });
      
    res.status(201).json({ contactProfessional: newContactProfessional });
  } catch (e) {
    handleError(res, e, 'Error creating ContactProfessional');
  }
};

const createReply = async (req, res) => {
    try {
      const userId = req.user.id;
      const { content } = req.body;
      const healthProfessional = await prisma.healthProfessional.findFirst({
        where: {userId:userId}
      });
      const senderId = healthProfessional.id;
      // Find the last contact ID for the recipient
      const lastContact = await prisma.contactProfessional.findFirst({
        where: { recipientId: senderId },
        orderBy: { sentAt: 'desc' },
      });
  
      if (!lastContact) {
        return res.status(404).json({ error: 'No previous contacts found for the recipient' });
      }
  
      const newReply = await prisma.reply.create({
        data: {
          contact: { connect: { id: lastContact.id } },
          sender: { connect: { id: userId } },
          content,
        },
      });
  
      res.status(201).json({ reply: newReply });
    } catch (e) {
      handleError(res, e, 'Error creating Reply');
    }
};
  
const getMessagesForSender = async (req, res) => {
  try {
    const senderId = req.user.id;
    const sentMessages = await prisma.contactProfessional.findMany({
        where: { senderId: senderId },
        include: {
          conversation: true,
          replies: { include: { sender: { select: { firstName: true, lastName: true } } } },
        },
      });
      
    res.status(200).json({ messages: sentMessages });
  } catch (e) {
    handleError(res, e, 'Error retrieving messages for sender');
  }
};

const getMessagesForRecipient = async (req, res) => {
  try {
    const userId = req.user.id;
    const healthProfessional = await prisma.healthProfessional.findFirst({
        where:{userId:userId}
    })
    const recipientId = healthProfessional.id;
    const receivedMessages = await prisma.contactProfessional.findMany({
        where: { recipientId: recipientId },
        include: {
          conversation: true,
          replies: true,
          sender: { select: { firstName: true, lastName: true } },
        },
      });

    res.status(200).json({ messages: receivedMessages });
  } catch (e) {
    handleError(res, e, 'Error retrieving messages for recipient');
  }
};

module.exports = {
  createContactProfessional,
  createReply,
  getMessagesForRecipient,
  getMessagesForSender,
};
