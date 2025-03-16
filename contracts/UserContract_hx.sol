// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 导入商家合约接口
import "./MerchantContract_hx.sol";

contract UserContract_hx {
    // 用户注册事件
    event UserRegistered_hx(address indexed user_hx, string userName_hx);
    // 用户评价商家事件
    event UserRated_hx(address indexed user_hx, address indexed merchant_hx, uint rating_hx);
    // 商家评价用户事件
    event MerchantRated_hx(address indexed merchant_hx, address indexed user_hx, uint rating_hx);
    // 余额变动事件
    event BalanceUpdated_hx(address indexed user_hx, int amount_hx, string description_hx);
    // 商品购买事件
    event ProductPurchased_hx(address indexed user_hx, uint price_hx, string description_hx);
    // 用户添加评论事件
    event UserCommentAdded(uint indexed productId, address indexed user, uint rating, string comment);

    mapping(address => bool) public users_hx;              // 用户映射，记录注册的用户地址
    mapping(address => int) public balances_hx;            // 用户余额映射
    mapping(address => Purchase[]) public transactionHistory_hx; // 用户交易历史映射
    mapping(string => address) private userAccounts_hx;    // 用户名到地址的映射
    mapping(address => string) private userPasswords_hx;   // 用户地址到密码的映射
    mapping(address => Comment[]) public userComments_hx;   // 用户评论映射

    // 商家合约地址
    address public merchantContractAddress_hx;
    address private owner_hx;

    struct Purchase {
        uint productId_hx;     // 商品ID
        uint price_hx;         // 商品价格
        uint timestamp_hx;     // 购买时间戳
    }

    struct Comment {
        uint productId_hx;     // 商品ID
        uint rating_hx;        // 评分
        string comment_hx;     // 评论内容
    }

    // 合约部署时初始化用户余额
    constructor() {
        balances_hx[msg.sender] = 10000;  // 初始余额为 10000
        owner_hx = msg.sender;
    }

    // 设置商家合约地址，仅合约所有者可调用
    function setMerchantContractAddress_hx(address _merchantContractAddress_hx) public {
        require(merchantContractAddress_hx == address(0), "Merchant contract address already set");
        require(msg.sender == owner_hx, "Only owner can call this function");
        merchantContractAddress_hx = _merchantContractAddress_hx;
    }

    // 注册用户
    function registerAsUser_hx(string memory _userName, string memory _password) public {
        require(!users_hx[msg.sender], "User already registered");
        users_hx[msg.sender] = true;
        userAccounts_hx[_userName] = msg.sender;
        userPasswords_hx[msg.sender] = _password;

        // 触发用户注册事件
        emit UserRegistered_hx(msg.sender, _userName);
    }

    // 用户登录，验证用户名和密码并返回用户地址
    function login_hx(string memory _userName, string memory _password) public view returns (address) {
        address userAddress = userAccounts_hx[_userName];
        require(userAddress != address(0), "User not found");
        require(keccak256(abi.encodePacked(userPasswords_hx[userAddress])) == keccak256(abi.encodePacked(_password)), "Incorrect password");
        return userAddress;
    }

    // 用户添加评论到商品
    function addComment_hx(uint _productId_hx, uint _rating_hx, string memory _comment_hx) public {
        require(_rating_hx >= 1 && _rating_hx <= 5, "Rating must be between 1 and 5");

        Comment memory newComment = Comment({
            productId_hx: _productId_hx,
            rating_hx: _rating_hx,
            comment_hx: _comment_hx
        });

        userComments_hx[msg.sender].push(newComment);

        // 触发用户添加评论事件
        emit UserCommentAdded(_productId_hx, msg.sender, _rating_hx, _comment_hx);
    }

      // 获取用户的所有评论
    function getUserComments_hx() public view returns (Comment[] memory) {
        return userComments_hx[msg.sender];
    }

    // 用户收到商家的评价后，进行反馈评价
    function respondToMerchantRating_hx(address _merchant_hx, uint _rating_hx) public {
        require(_rating_hx >= 1 && _rating_hx <= 5, "Rating must be between 1 and 5");
        require(users_hx[msg.sender], "Only registered users can call this function");

        // 向商家合约发送评价请求
        (bool success, ) = merchantContractAddress_hx.call(
            abi.encodeWithSignature("rateUser_hx(address,uint256,uint256)", _merchant_hx, 0, _rating_hx)
        );
        require(success, "Failed to call rateUser function in MerchantContract_hx");

        // 触发商家评价用户事件
        emit MerchantRated_hx(_merchant_hx, msg.sender, _rating_hx);
    }

    // 获取用户余额
    function getBalance_hx() public view returns (int) {
        return balances_hx[msg.sender];
    }

    // 获取用户交易历史
    function getTransactionHistory_hx() public view returns (Purchase[] memory) {
        return transactionHistory_hx[msg.sender];
    }

    // 获取用户名对应的用户地址
    function getUserAddress_hx(string memory _userName) public view returns (address) {
        return userAccounts_hx[_userName];
    }

    // 验证用户用户名和密码
    function verifyPwd_hx(string memory _userName, string memory _password) public view returns (bool) {
        address userAddress = userAccounts_hx[_userName];
        require(userAddress != address(0), "User not found");
        return keccak256(abi.encodePacked(userPasswords_hx[userAddress])) == keccak256(abi.encodePacked(_password));
    }

    // 更新余额的函数，只允许合约创建者或系统合约调用
    function updateBalance_hx(address user_hx, int256 amount_hx, string memory description_hx) public {
        require(msg.sender == owner_hx, "Only owner can call this function");
        require((balances_hx[user_hx] + amount_hx) >= 0, "Insufficient balance"); // 确保余额不会为负值
        balances_hx[user_hx] += amount_hx; // 更新余额
        emit BalanceUpdated_hx(user_hx, amount_hx, description_hx);
    }

    // 用户购买商品，使用余额进行交易
    function purchaseProduct_hx(uint _productId_hx, uint _price_hx) public {
        require(balances_hx[msg.sender] >= int(_price_hx), "Insufficient balance");

        // 减少用户余额
        balances_hx[msg.sender] -= int(_price_hx);

        // 将购买信息添加到用户的交易历史中
        Purchase memory newPurchase = Purchase({
            productId_hx: _productId_hx,
            price_hx: _price_hx,
            timestamp_hx: block.timestamp
        });

        transactionHistory_hx[msg.sender].push(newPurchase);

        // 触发商品购买事件
        emit ProductPurchased_hx(msg.sender, _price_hx, "Product purchased");
    }

    // 根据用户的账户地址获取用户合约地址
    function creatorOwnerMap_hx(address /* _owner */) public view returns (address) {
        return address(this); // 返回当前合约地址
    }
}
