const mongoose = require('mongoose');
const { Schema } = mongoose;
const ObjectId = Schema.Types.ObjectId;

const recordSchema = new Schema({
    rc_user_id: {
        type: ObjectId,
        required: true,
        unique: true,
        default: () => new mongoose.Types.ObjectId()
    },
    rc_fd_num: {
        type: String,
        required: true
    },
    rc_fd_category: {
        type: String,
        required: true,
        enum: ['기관 사칭형 보이스피싱', '대출 사기형 보이스피싱', '기타']
    },
    rc_fd_level: {
        type: Number, 
        required: true
    }, 
    rc_audio_file: {
        type: ObjectId,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

recordSchema.virtual('rc_fd_level_str').get(function() {
    if (this.rc_fd_level >= 80) {
        return '위험';
    } else if (this.rc_fd_level >= 60) {
        return '경고';
    } else if (this.rc_fd_level >= 40) {
        return '보통';
    } else {
        return '낮음';
    }
});

recordSchema.set('toJSON', { virtuals: true });
recordSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Record', recordSchema);
