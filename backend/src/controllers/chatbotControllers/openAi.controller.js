const chatBot = require('./chatbot');
const handleError = require('../../helpers');
const { PrismaClient } = require("@prisma/client");
const { error } = require('console');
const prisma = new PrismaClient();

const chatBotController = async(req, res) => {
    try{
        const userId = req.user.id;
        const userMessage = req.body;

        const openAi = chatBot.generateOpenAIPayload(userId, userMessage);

        res.status(201).json({ response: openAi });
    }catch (e) {
        handleError(res, e, 'Error adding allergen');
    }
}

const getLastResponse = async(req, res) => {
    
    try{
        const userId = req.user.id;
        
        const openAiResponse = await prisma.openAiResponse.findFirst({
            where : { userId: userId},
            orderBy : {timestamp: 'desc'},
        })

        if (!openAiResponse){
           return res.status(404).json({error: 'no response found'});
        }
        
        res.status(200).json({openAiResponse});
    }catch(e){
        handleError(res, e, 'Error retrieving OpenAI response');
    }
}

module.exports = {chatBotController, getLastResponse};