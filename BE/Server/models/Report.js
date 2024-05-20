const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
    rc_user_id: {
        type: ObjectId,
        required: true,
        unique: true,
        default : new mongoose.Types.ObjectId
    },
    rp_phoneNumber: {
        type: String,
        required: true
    },
    rc_description: {
        type: String
    },
    createdAt: {
        type: Date,
        default: Date .now
    }
});

module.exports = mongoose.model('Report', reportSchema);