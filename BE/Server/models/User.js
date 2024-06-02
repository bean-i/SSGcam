const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');

const userSchema = mongoose.Schema({
    user_name: {
        type: String,
        maxlength: 50,
        required: true
    },
    user_id: {
        type: String,
        required: true,
        unique: true
    },
    user_pw: {
        type: String,
        minlength: 5,
        required: true
    },
    user_pt_num: {
        type: [String],
        required: false 
    },
    role: {
        type: Number,
        default: 0
    }
})

userSchema.pre('save', function( next ) {
    const user = this;

    if(user.isModified('user_pw')) {
        bcrypt.genSalt(10, function(err, salt) {
            if (err) {
                return next(err);
            }

            bcrypt.hash(user.user_pw, salt, function(err, hash) {
                if (err) {
                    return next(err);
                }
                user.user_pw = hash;
                return next();
            });
        });
    }
    else {
        return next();
    }
});

userSchema.methods.comparePassword = function(plainPassword) {
    const user = this;
    return bcrypt.compare(plainPassword, this.user_pw)
}

userSchema.methods.generateToken = function() {
    const user = this;
    const token = jwt.sign({userId: user._id.toJSON()}, 'secretToken', {expiresIn: '1h'});
    return token;
}

userSchema.statics.findByToken = async function(token) {
    var user = this;

    try {
        const decoded = await new Promise((resolve, reject) => {
            jwt.verify(token, 'secretToken', (err, decoded) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(decoded);
                }
            });
        });
        const foundUser = await user.findOne({"_id" : decoded.userId });
        return foundUser;
    } catch (err) {
        throw err;
    }
};

const User = mongoose.model('User', userSchema);

module.exports = { User };