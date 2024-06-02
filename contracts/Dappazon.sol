// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {

// Define the varoables and variable types for the smart contract
    address public owner;
    event List(string name, uint256 cost, uint256 stock);
    event Buy(address buyer, uint256 orderID, uint256 itemID);

// Add a only owner function so only the person who deploys the smart contract can call certain functions
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
// Define a Item structure type. This is the info that each new item must have
    struct Item {
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order {
        uint256 timestamp;
        uint256 item;
    }



    mapping(uint256 => Item)public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;


    constructor (){
        owner = msg.sender;
    }

// Add a new item to the list
    function list(uint256 _id, string memory _name, string memory _category, string memory _image, uint256 _cost, uint256 _rating, uint256 _stock) public onlyOwner() {
        Item memory item = Item(_id, _name, _category, _image, _cost, _rating, _stock);
        items[_id] = item;
        emit List(_name, _cost, _stock);
        }

    function buy(uint256 _id) public payable {
        // fetch item
        Item memory item = items[_id];
        // require statements for sufficient funds, and enough stock
        require(msg.value >= item.cost);
        require(item.stock >= 1);


        // Create order 
        Order memory order = Order(block.timestamp, _id);
        // Add order for user
        orderCount[msg.sender]++; 
        orders[msg.sender][orderCount[msg.sender]] = order;

        // Subtract stock
        items[_id].stock = items[_id].stock - 1;

        // Emits a buy event
        emit Buy(msg.sender, orderCount[msg.sender], _id);

    }

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}

    

