const mongoose = require('mongoose');
// const ObjectId = mongoose.Schema.Types.ObjectId; 

const recordSchema = new mongoose.Schema({
    rc_user_id: {
        type: String,
        required: true,
        unique: true,
    },
    rc_fd_num: {
        type: String,
        required: true
    },
    rc_fd_category: {
        type: String,
        required: true,
        enum: ['수사기관사칭형', '대출사기형', '기타']
    },
    rc_fd_level: {
        type: String,
        required: true,
        enum: ['낮음', '보통', '높음']
    },
    rc_audio_file: {
        type: String,
        //type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date .now
    }
});

module.exports = mongoose.model('Record', recordSchema);