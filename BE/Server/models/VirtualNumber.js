const mongoose = require('mongoose');

const virtualNumberSchema = mongoose.Schema({
    vn_id: {
        type: String,
        required: true,
        maxlength: 20,
        ref: 'User' 
    },
    vn_twilioID: {
        type: String,
        required: true,
        maxlength: 20
    },
    vn_number: {
        type: String,
        required: true,
        maxlength: 20,
        unique: true 
    }
});

const VirtualNumber = mongoose.model('VirtualNumber', virtualNumberSchema);

module.exports = { VirtualNumber }
