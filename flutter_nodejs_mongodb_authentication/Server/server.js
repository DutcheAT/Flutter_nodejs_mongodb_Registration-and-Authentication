var express = require('express');
var app = express();
var mongoose=require('mongoose'); 
require('dotenv').config();
var jwt = require('jsonwebtoken');



async function connectDB(){
    await mongoose.connect(process.env.MONGODB_CONNECTION_STRING); 
    console.log('Connected');
}
 connectDB();

const schema = new mongoose.Schema({email: String, password: String });
const User = mongoose.model('User', schema);
app.use(express.json({extended:false})); 

app.get('/', (req, res)=> res.send("Hello world!"));


app.post('/signup', async(req, res)=>{

 const {email,password }= req.body;

 let user=await User.findOne({
  email,
});
 
 if (user) {
  return res.status(401).json({ error: 'Email already taken'});
  }

 user=new User({
    email,
    password,
});
console.log(user);
await user.save();

var token = jwt.sign({ id: user.id }, process.env.SECRET_KEY);
res.json({token: token});
  
});



app.post('/login', async(req, res)=>{

  const {email,password }= req.body;
 
 let user=await User.findOne({
     email,
 });
    
 if (!user) {
  return res.status(401).json({ error: 'Invalid credentials' });
  }
 if (user.password!==password){
  return res.json({mdg:"Incorrect password"});
 }

 var token = jwt.sign({ id: user.id }, process.env.SECRET_KEY);
 res.json({token: token});

 });



app.listen(3000,() =>console.log("Server is running on port 3000")); 
