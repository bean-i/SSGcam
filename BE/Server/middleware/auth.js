const { User } = require('../models/User');
const jwt = require("jsonwebtoken");
//const secret = process.env.JWT_SECRET_KEY;

let auth = async (req, res, next) => {
    try {
        let token = req.cookies.x_auth;
        
        // 토큰 검증
        jwt.verify(token, secret, async (error, decoded) => {
            if (error) {
                return res.json({ isAuth: false, error: true });
            }
            let user = await User.findOne({_id: decoded.id});
            if (!user) {
                return res.json({ isAuth: false, error: true });
            }

            req.token = token;
            req.user = user;
            next();
        });
    } catch (err) {
        return res.status(500).send(err);
    }
};

module.exports = { auth };