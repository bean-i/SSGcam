const mongoose = require('mongoose');
const { Schema } = mongoose;
const ObjectId = Schema.Types.ObjectId;

const fraudCasesSchema = mongoose.Schema({
    fc_id: {
        type: Number,
        required: true,
        unique: true 
    },
    fc_user: {
        type: ObjectId, // 수정
        ref: 'User', 
        maxlength: 20
    },
    fc_number: {
        type: String,
        required: true,
        maxlength: 20
    },
    fc_description: {
        type: String,
        maxlength: 255
    },
    fc_date: {
        type: Date
    }
});

const FraudCases = mongoose.model('FraudCases', fraudCasesSchema);

module.exports = { FraudCases };
