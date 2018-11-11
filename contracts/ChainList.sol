pragma solidity ^0.4.18;

import "./Ownable.sol";

//Contracts support multiple inheritance
                    //Extend key word "is"
contract ChainList is Ownable {

  struct Article{
    uint id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;
  }

  //state variables
  //address owner;  //declared in Ownable.sol
  mapping(uint => Article) public articles;
  uint articleCounter;

  //events
  //declaring events
  event LogSellArticle(
    uint indexed _id,
    address indexed _seller,  //indexed: it will be possible to filter events by value in logs
    string _name,
    uint256 _price
    );

  event LogBuyArticle(
    uint indexed _id,
    address indexed _seller,
    address indexed _buyer,
    string _name,
    uint256 _price
    );

    //modifier
    /* modifier onlyOwner(){    //declared in Ownable.sol
      require(msg.sender == owner);
      _;  //placeholder that represents the code of the function that the modifier is applied to
    } */

  /* constructor() public{  //This is done in Ownable.sol
    //constructo is called only once when contract is deployed
    //sellArticle("Default Article", "This is an article set by default", 1000000000000000000);
    owner = msg.sender;
  } */

  function kill() public onlyOwner {
    //only allow for contract owner
    //require(owner == msg.sender);

    selfdestruct(owner);
  }

  //sell an article
  function sellArticle(string _name, string _description, uint256 _price) public{
    //a new article
    articleCounter++;

    articles[articleCounter] = Article(
        articleCounter,
        msg.sender,
        0x0,
        _name,
        _description,
        _price
      );

    emit LogSellArticle(articleCounter, msg.sender, _name, _price);
  }

  //get an article
  /* function getArticle() public view returns(
    address _seller,
    address _buyer,
    string _name,
    string _description,
    uint256 _price
    ){
      return(seller, buyer, name, description, price);
  } */

  //fetch the number of articles in the contract
  function getNumberOfArticles() public view returns (uint) {
    return articleCounter;
  }

  //fetch and return all article IDs for aticles still for sale
  function getArticlesForSale() public view returns (uint[]) {  //we cannot return as array of structur types from the function in solidity at this point
    //prepare output array
    uint[] memory articleIds = new uint[](articleCounter);  //local variables must be declared with a fixed size
    /*memory: this is necessary because by default array type local variablesas well as any other complex things like structur
    type stored in storage which is much more expensive than storing it in memory */

    uint numberOfArticlesForSale = 0;
    // iterate over articles
    for(uint i = 1; i <= articleCounter;  i++) {
      // keep the ID if the article is still for sale
      if(articles[i].buyer == 0x0) {
        articleIds[numberOfArticlesForSale] = articles[i].id;
        numberOfArticlesForSale++;
      }
    }

    // copy the articleIds array into a smaller forSale array
    uint[] memory forSale = new uint[](numberOfArticlesForSale);
    for(uint j = 0; j < numberOfArticlesForSale; j++) {
      forSale[j] = articleIds[j];
    }
    return forSale;
  }

  //buy an article
  function buyArticle(uint _id) payable public {  //payable: this function may recieve value (ether from it's caller), if you not declare payable, you cannot send value to it
    //check whether there is an article for sale
    /* require(seller != 0x0); */
    require(articleCounter > 0);   //

    // we check that the article exist
    require(_id > 0 && _id <= articleCounter);

    //retrieve the article
    Article storage article = articles[_id];  //storage is the default for complex type local variables like this one

    //check that article has not been sold yet
    /* require(buyer == 0x0); */
    require(article.buyer == 0x0);

    //we don't allow the seller to buy his own article
    require(msg.sender != article.seller);

    //check that the value sent corresponds to the price of the article
    require(msg.value == article.price);

    //keep buyer's information
    article.buyer = msg.sender;

    //the buyer can pay the seller
    article.seller.transfer(msg.value);

    //trigger the event
    emit LogBuyArticle(_id, article.seller, article.buyer, article.name, article.price);
  }

  /*there are sevaral ways to interrupt a contract function excution
  * throw
  * assert
  * require
  * revert
    same consequnces
    1. value gets refunded to the msg sender
    2. state changes reverted
    3. function interrupted
    4. gas up to that point spent not get refunded to the msg sender
    5. REVERT opcode returned (just like throwing an exception)

    these make contract function atomic
  */
}
