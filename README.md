# BlockCampus-Market
去中心化校园二手市场 DApp | A decentralized campus second-hand market DApp.
# 校园二手市场 DApp | Campus Second-hand Market DApp

## 1. 项目简介 | Project Introduction
本项目是一个基于区块链的校园二手市场 DApp，用户可以通过去中心化的方式进行商品交易，保证交易透明度、安全性，并降低中间成本。

This project is a blockchain-based campus second-hand market DApp, allowing users to trade items in a decentralized manner, ensuring transaction transparency, security, and reducing intermediary costs.

### 1.1 背景与动机 | Background & Motivation
在传统的校园二手市场中，交易通常依赖于社交平台或线下交易，容易出现以下问题：
- **信息不透明**：卖家可能会隐藏商品瑕疵，导致买家损失。
- **安全性低**：使用现金或第三方支付可能带来欺诈风险。
- **交易效率低**：信息散乱，难以找到合适的商品。

通过区块链技术，DApp 提供了一种去中心化的解决方案，实现安全、高效、透明的交易环境。

---

## 2. 功能 | Features

### 2.1 用户功能 | User Features
#### 用户注册 & 登录 | User Registration & Login
- 用户可使用 MetaMask 等钱包进行注册和登录，所有信息加密存储（可选邮箱认证）。
- Users can register and log in using wallets like MetaMask, with encrypted data storage (optional email authentication).

#### 发布商品 | Listing Items
- 商家可发布二手商品，包括名称、描述、价格、数量、图片、时间戳等，图片存储至 IPFS。
- Sellers can list second-hand items with name, description, price, quantity, image, timestamp, etc. Images are stored on IPFS.

#### 商品下架 | Delisting Items (Optional)
- 商品售罄后可下架。
- Items can be delisted after they are sold out.

#### 浏览商品 | Browsing & Filtering Items
- 用户可浏览所有商品，并按类别、价格筛选，支持收藏、举报、翻页等。
- Users can browse all items and filter by category and price. Features include bookmarking, reporting, and pagination.

#### 商品明细页面 | Item Details Page
- 详细查看商品信息。
- View detailed item information.

#### 购买商品 | Purchasing Items
- 选择商品并通过智能合约进行安全交易。
- Select items and complete transactions securely via smart contracts.

#### 资金管理 | Fund Management
- 用户可查看钱包余额和交易记录。
- Users can check wallet balance and transaction history.

#### 评价系统 | Review System
- 交易完成后，买卖双方可互相评价，提升可信度，支持图片上传。
- Buyers and sellers can review each other after transactions, improving trust. Image uploads are supported.

---

## 3. 技术栈 | Tech Stack

### 3.1 后端 | Backend
- Solidity（智能合约编写 | Smart Contract Development）
- Hardhat（智能合约部署工具 | Smart Contract Deployment）
- Express（后端 API | Backend API）

### 3.2 前端 | Frontend
- Scaffold-ETH 2（前端框架 | Frontend Framework）
- IPFS（去中心化存储 | Decentralized Storage）
- Web3.js & Ethers.js（区块链交互 | Blockchain Interaction）

### 3.3 区块链平台 | Blockchain Platform
- Geth（本地区块链 | Local Blockchain）
- 测试公链 | Testnet

### 3.4 开发工具 | Development Tools
- MetaMask（钱包 & 测试网络 | Wallet & Test Network）
- Visual Studio Code（代码编辑器 | Code Editor）

---

## 4. 智能合约安全性 | Smart Contract Security
为了保障用户资产安全，智能合约实现了以下安全机制：
- **交易不可逆**：所有交易一旦确认上链，不可篡改，确保资金安全。
- **权限管理**：仅商品所有者可以下架商品，防止恶意操作。
- **防范重放攻击**：引入 nonce 机制，避免相同交易重复执行。
- **合约升级性**：采用代理模式（Proxy Pattern），便于后续合约升级。

---

## 5. 部署 & 运行 | Deployment & Execution

### 5.1 克隆项目 | Clone the Repository

git clone https://github.com/your-repo/BlockCampus-Market.git
cd BlockCampus-Market


### 5.2 安装依赖 | Install Dependencies

npm install


### 5.3 启动本地区块链（可选）| Start Local Blockchain (Optional)

npx hardhat node


### 5.4 部署智能合约 | Deploy Smart Contracts

npx hardhat run scripts/deploy.js --network localhost


### 5.5 启动前端 | Start the Frontend

npm start

---

本项目致力于打造一个安全、高效、透明的校园二手市场，欢迎贡献代码和反馈！

