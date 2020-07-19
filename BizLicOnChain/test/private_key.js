var keythereum = require("keythereum");  
var datadir = "/Users/guanhongchang/testNet"; //data存放的地址路径
var address= "0x886aeec3425061ee24928f5b0f3745d051948caa";//要小写  
const password = "1234567890"; //账户密码
var keyObject = keythereum.importFromFile(address, datadir);  
var privateKey = keythereum.recover(password, keyObject);  

console.log(privateKey.toString('hex'));
