// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MerchantContract_hx {
    // 结构体：商品信息
    struct Product_hx {
        uint id_hx;                     // 商品ID1
        address seller_hx;              // 卖家地址2
        address buyer_hx;               // 买家地址3
        string name_hx;                 // 商品名称4
        string description_hx;          // 商品描述5
        uint price_hx;                  // 商品价格6
        uint quantity_hx;               // 商品数量7
        bool available_hx;              // 商品是否可购买8
        string imgCID_hx;               // 商品图片CID9
        uint timestamp_hx;              // 商品上传时间戳10
        // 评价相关
        Review_hx review_hx;            // 评价信息结构体11
    }

    // 结构体：评价信息
    struct Review_hx {
        address user_hx;                // 用户地址
        string comment_hx;              // 评价内容
        string reply_hx;                // 商家回复内容
        uint rating_hx;                 // 评分
    }

    // 商品映射，通过商品ID检索商品信息
    mapping(uint => Product_hx) public products_hx;
    // 商品计数器，记录已添加的商品数量
    uint public productCounter_hx;
    // 商家注册映射，记录已注册的商家
    mapping(address => bool) public merchants_hx;
    // 商家用户名映射，通过用户名检索商家地址
    mapping(string => address) private merchantAccounts_hx;
    // 记录商家已查看评价的商品映射
    mapping(uint => bool) public reviewedProducts_hx;

    // 事件：商品添加
    event ProductAdded_hx(uint id_hx, string name_hx, uint price_hx, uint quantity_hx, string imgCID_hx);
    // 事件：商品购买
    event ProductPurchased_hx(uint id_hx, string name_hx, address buyer_hx);
    // 事件：评价添加
    event ReviewAdded_hx(uint id_hx, address user_hx, uint rating_hx, string comment_hx);
    // 事件：商家回复评价
    event ReviewReplied_hx(uint id_hx, address seller_hx, string reply_hx);
    // 事件：商家查看评价
    event ReviewViewed_hx(uint indexed id_hx, address indexed seller_hx);

    // 注册为商家
    function registerAsMerchant_hx(string memory _userName_hx) public {
        require(!merchants_hx[msg.sender], "Merchant already registered");
        merchants_hx[msg.sender] = true;
        merchantAccounts_hx[_userName_hx] = msg.sender;
    }

    // 添加商品
    function addProduct_hx(string memory _name_hx, string memory _description_hx, uint _price_hx, uint _quantity_hx, string memory _imgCID_hx) public {
        require(merchants_hx[msg.sender], "Only merchants can add products");
        productCounter_hx++;
        products_hx[productCounter_hx] = Product_hx({
            id_hx: productCounter_hx,
            seller_hx: msg.sender,
            buyer_hx: address(0),
            name_hx: _name_hx,
            description_hx: _description_hx,
            price_hx: _price_hx,
            quantity_hx: _quantity_hx,
            available_hx: _quantity_hx > 0,
            imgCID_hx: _imgCID_hx,
            timestamp_hx: block.timestamp,
            review_hx: Review_hx({
                user_hx: address(0),
                comment_hx: "",
                reply_hx: "",
                rating_hx: 0
            })
        });
        emit ProductAdded_hx(productCounter_hx, _name_hx, _price_hx, _quantity_hx, _imgCID_hx);
    }

    // 购买商品
    function purchaseProduct_hx(uint _productId_hx) public payable {
        Product_hx storage product_hx = products_hx[_productId_hx];
        require(product_hx.id_hx != 0, "Product does not exist");
        require(product_hx.available_hx, "Product is not available for purchase");
        require(product_hx.quantity_hx > 0, "Product is out of stock");
        require(msg.value == product_hx.price_hx, "Incorrect value sent");

        product_hx.buyer_hx = msg.sender;
        product_hx.quantity_hx--;
        if (product_hx.quantity_hx == 0) {
            product_hx.available_hx = false;
        }

        payable(product_hx.seller_hx).transfer(msg.value);
        emit ProductPurchased_hx(_productId_hx, product_hx.name_hx, msg.sender);
    }

    // 商家回复评价
    function replyReview_hx(uint _productId_hx, string memory _reply_hx) public {
        Product_hx storage product_hx = products_hx[_productId_hx];
        require(product_hx.id_hx != 0, "Product does not exist");
        require(product_hx.seller_hx == msg.sender, "Only the seller can reply to the review");
        require(bytes(product_hx.review_hx.comment_hx).length > 0, "No review to reply to");

        product_hx.review_hx.reply_hx = _reply_hx;
        emit ReviewReplied_hx(_productId_hx, msg.sender, _reply_hx);
    }

    // 商家查看评价
    function viewProductReviews_hx(uint _productId_hx) public {
        require(merchants_hx[msg.sender], "Only merchants can view reviews");
        require(products_hx[_productId_hx].id_hx != 0, "Product does not exist");
        require(!reviewedProducts_hx[_productId_hx], "Reviews already viewed for this product");

        reviewedProducts_hx[_productId_hx] = true;
        emit ReviewViewed_hx(_productId_hx, msg.sender);
    }

    // 设置商品上架或下架
    function setProductOnSale_hx(uint _productId_hx, bool _onSale_hx) public {
        require(products_hx[_productId_hx].id_hx != 0, "Product does not exist");
        require(products_hx[_productId_hx].seller_hx == msg.sender, "Only the seller can modify the product");

        products_hx[_productId_hx].available_hx = _onSale_hx;
    }

    // 获取所有商品的ID数组
    function getProductIds_hx() public view returns (uint[] memory) {
        uint[] memory ids_hx = new uint[](productCounter_hx);
        for (uint i = 1; i <= productCounter_hx; i++) {
            ids_hx[i - 1] = products_hx[i].id_hx;
        }
        return ids_hx;
    }

    // 根据商品ID获取商品基本信息
    function getProductInfoById_hx(uint _productId_hx) public view returns (uint, address, address, string memory, string memory, uint, uint, bool, string memory, uint) {
        require(products_hx[_productId_hx].id_hx != 0, "Product does not exist");

        Product_hx storage product_hx = products_hx[_productId_hx];
        return (
            product_hx.id_hx,
            product_hx.seller_hx,
            product_hx.buyer_hx,
            product_hx.name_hx,
            product_hx.description_hx,
            product_hx.price_hx,
            product_hx.quantity_hx,
            product_hx.available_hx,
            product_hx.imgCID_hx,
            product_hx.timestamp_hx
        );
    }

    // 根据商品ID获取评价信息
    function getProductReviewInfo_hx(uint _productId_hx) public view returns (address, string memory, string memory, uint) {
        require(products_hx[_productId_hx].id_hx != 0, "Product does not exist");

        Product_hx storage product_hx = products_hx[_productId_hx];
        return (
            product_hx.review_hx.user_hx,
            product_hx.review_hx.comment_hx,
            product_hx.review_hx.reply_hx,
            product_hx.review_hx.rating_hx
        );
    }

    // 检查商品是否存在
    function productExists_hx(uint _productId_hx) public view returns (bool) {
        return (products_hx[_productId_hx].id_hx != 0);
    }

    // 获取商家合约地址的余额
    function getContractBalance_hx() public view returns (uint) {
        return address(this).balance;
    }

    // 获取商品卖家地址
    function getProductSeller_hx(uint _productId_hx) public view returns (address) {
        require(products_hx[_productId_hx].id_hx != 0, "Product does not exist");
        return products_hx[_productId_hx].seller_hx;
    }

    // 验证用户名密码是否匹配
    function verifyPwd_hx(string memory _userName_hx, string memory /* _password_hx */) public view returns (bool) {
        address merchantAddress_hx = merchantAccounts_hx[_userName_hx];
        require(merchants_hx[merchantAddress_hx], "Merchant does not exist");
        return true;
    }

    // 根据所有者地址获取商家合约地址
    function creatorMerchantMap_hx(address _owner_hx) public view returns (address) {
        require(merchants_hx[_owner_hx], "Merchant does not exist");
        return address(this);
    }
}
