var ChainList = artifacts.require("./ChainList.sol");
// var chai = require('chai');

//test suit
//(the name of the contract we want to test, function)
contract('ChainList', function(accounts){
  //defining test case
  it("Should be initialized with empty values", function(){
    //test
    return ChainList.deployed().then(function(instance){
      return instance.getArticle();
    }).then(function(data){
      assert.equal(data[0], 0x0, "seller must be empty");
      assert.eqaul(data[1], "", "article name must be empty");
      assert.equal(data[2], "", "article description must be empty");
      assert.equal(data[3].toNumber(), 0, "article price must be zero");
    })
  })
});
