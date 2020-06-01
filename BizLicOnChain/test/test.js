var EncryptUtils = artifacts.require("EncryptUtils");

contract('EncryptUtils Test', function(accounts){
  it('测试验签', function(){
    return EncryptUtils.deployed().then(async function(instance){
    	let licContent = "{uniScId:'123100008654367537',corpName:'某某股份有限公司',leadName:'李四',indsyCode:'6432',regCpt:1250000.00,provDate:'2020-05-26',limitTo:'2025-05-26',issueOrgan:'上海市市场监督局'}";
    	let sign = await web3.eth.accounts.sign(licContent,'c620a4325cf94591cecd800d0e890cd8fe3adfaf7b93a870ebdcf96132b409ac');
    	return instance.verificate(licContent,sign.signature,accounts[1]);
    }).then(function(result){
      assert.equal(result.valueOf(),true);
    });
  });
  
});