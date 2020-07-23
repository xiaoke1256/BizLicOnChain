var keythereum = require("keythereum");  
var datadir = "C:\\Program Files\\Geth\\data"; //data存放的地址路径
var address= "aefe184653e506426daab8369504ce3a2d95b68c";//要小写  
const password = "1234567890"; //账户密码
var keyObject = keythereum.importFromFile(address, datadir);  
var privateKey = keythereum.recover(password, keyObject);  

console.log(privateKey.toString('hex'));
