var express = require('express');
var app = express();
var mongoose=require('mongoose'); 
require('dotenv').config();


async function connectDB(){
    await mongoose.connect(process.env.MONGODB_CONNECTION_STRING); 
    console.log('Connected');
}
 connectDB();

app.use(express.json({extended:false})); 

app.get('/', (req, res)=> res.send("Hello world!"));


app.post('/signup', async(req, res)=>{

 const {phonenumber,password }= req.body;

 console.log(phonenumber);
 console.log(password);
const schema = new mongoose.Schema({ phonenumber: String, password: String });
const User = mongoose.model('User', schema);

let user=new User({
    phonenumber,
    password,
});
console.log(user);
await user.save();
res.json({token:"1234567890"})
  // return res.send("sign up api route ");
});

app.listen(3000,() =>console.log("Hello world!")); 
