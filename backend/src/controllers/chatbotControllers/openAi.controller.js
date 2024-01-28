const chatBot = require('./chatbot');

const charBotController = async(req, res) => {
    try{
        const userId = req.user.id;
        const userMessage = req.body;

        const openAi = chatBot.generateOpenAIPayload(userId, userMessage);
        
    }catch(error){

    }
}