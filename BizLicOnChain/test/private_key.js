var keythereum = require("keythereum");  
var datadir = "C:\\Program Files\\Geth\\data1"; //data存放的地址路径
var address= "456247d681c799bf184085c2e1db8409add60c34";//要小写  
const password = "123456"; //账户密码
var keyObject = keythereum.importFromFile(address, datadir);  
var privateKey = keythereum.recover(password, keyObject);  

console.log(privateKey.toString('hex'));
