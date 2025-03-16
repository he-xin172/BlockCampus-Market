async function loadContracts() {
  try {
    // 获取 address.json 文件
    const response = await fetch('../address_hx.json');
    if (!response.ok) {
      throw new Error('Failed to fetch address_hx.json');
    }
    const contractAddrArray = await response.json();

    // 并行加载商家合约和用户合约的编译后 JSON 文件
    const [MerchantContract_hx, UserContract_hx] = await Promise.all([
      fetch('../artifacts/contracts/MerchantContract_hx.sol/MerchantContract_hx.json').then(response => response.json()),
      fetch('../artifacts/contracts/UserContract_hx.sol/UserContract_hx.json').then(response => response.json())
    ]);

    // 创建一个新的 Web3 实例，并连接到用户的以太坊网络
    const web3 = new Web3(window.ethereum);

    // 实例化商家合约和用户合约对象，使用其 ABI 和部署地址
    const merchantAddr = contractAddrArray[0];
    const userAddr = contractAddrArray[1];
    const merchantContract = new web3.eth.Contract(MerchantContract_hx.abi, merchantAddr);
    const userContract = new web3.eth.Contract(UserContract_hx.abi, userAddr);

    // 返回实例化后的商家合约和用户合约对象
    return {
      merchantContract,
      userContract
    };
  } catch (error) {
    console.error('加载合约失败:', error);
    throw error;
  }
}

async function fetchProductIds(merchantContract) {
  try {
    const productIds = await merchantContract.methods.getProductIds_hx().call();
    return productIds;
  } catch (error) {
    console.error('获取商品ID列表失败:', error);
    throw error;
  }
}

async function getProductDetails(merchantContract, productId) {
  try {
    const productInfo = await merchantContract.methods.getProductInfoById_hx(productId).call();
    return productInfo;
  } catch (error) {
    console.error('获取商品详情失败:', error);
    throw error;
  }
}

// document.addEventListener('DOMContentLoaded', loadContracts);
// export {fetchProductIds, getProductDetails };

// 在 DOMContentLoaded 事件触发后执行 loadContracts 函数
document.addEventListener('DOMContentLoaded', async () => {
  try {
    const contracts = await loadContracts();
    console.log('合约加载成功:', contracts);

    // 在这里可以继续执行其他初始化操作或者调用其他函数
    const merchantContract = contracts.merchantContract;
    const productIds = await fetchProductIds(merchantContract);
    console.log('商品ID列表:', productIds);

    // 示例：获取第一个商品的详情
    if (productIds.length > 0) {
      const productId = productIds[0];
      const productInfo = await getProductDetails(merchantContract, productId);
      console.log('第一个商品详情:', productInfo);
    }

  } catch (error) {
    console.error('页面初始化失败:', error);
    // 可以在页面上显示错误信息或者执行其他错误处理逻辑
  }
});