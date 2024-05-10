const express = require('express')
const app = express()
const port = 3000
const bodyParser = require('body-parser');
const { User } = require('./models/User');

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

const mongoose = require('mongoose')
mongoose.connect('mongodb+srv://isakacindy:PNWADCm19pGj3bP6@server.2n9yl1k.mongodb.net/', {
}).then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err))

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.post('/register', (req, res) => {
    const user = new User(req.body)

    user.save().then(()=>{
        res.status(200).json({
            success:true
        })
    }).catch((err)=>{
        return res.json({success:false, err})
    })
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})