const mongoose = require('mongoose');

const chatBotSchema = mongoose.Schema({
    scenario_id: {
        type: String,
        required: true,
        maxlength: 255,
        unique: true 
    },
    scenario_answer: {
        type: String,
        required: true,
        maxlength: 255
    }
});

const ChatBot = mongoose.model('ChatBot', chatBotSchema);

module.exports = { ChatBot }
