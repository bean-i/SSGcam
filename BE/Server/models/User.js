const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');


const userSchema = mongoose.Schema({
    name: {
        type: String,
        maxlength: 50,
        required: true
    },
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        minlength: 5,
        required: true
    },
    confirmPassword: {
        type: String,
        minlength: 5,
        required: true 
    },
    parentContact: {
        type: String,
        required: false 
    },
    role: {
        type: Number,
        default: 0
    },
    token: {
        type: String
    },
    tokenExp: {
        type: Number
    }
})

userSchema.pre('save', function( next ) {
    const user = this;

    if(user.isModified('password')) {
        bcrypt.genSalt(10, function(err, salt) {
            if (err) {
                return next(err);
            }

            bcrypt.hash(user.password, salt, function(err, hash) {
                if (err) {
                    return next(err);
                }
                user.password = hash;
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
    return bcrypt.compare(plainPassword, this.password)
}

userSchema.methods.generateToken = function() {
    user = this;
    const token = jwt.sign(user._id.toJSON(), 'secretToken');
    user.token = token;

    return user.save();
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
        const foundUser = await user.findOne({"_id" : decoded, "token" : token});
        return foundUser;
    } catch (err) {
        throw err;
    }
};

const User = mongoose.model('User', userSchema)

module.exports = { User }