const mongoose = require('mongoose');

const recordSchema = new mongoose.Schema({
    rc_user_id: {
        type: ObjectId,
        required: true,
        unique: true,
        default : new mongoose.Types.ObjectId
    },
    rc_phoneNumber: {
        type: String,
        required: true
    },
    rc_riskLevel: {
        type: String,
        required: true,
        enum: ['낮음', '보통', '높음']
    },
    rc_voiceRecord: {
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date .now
    }
});

module.exports = mongoose.model('Record', recordSchema);