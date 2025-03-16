const fs = require('fs-extra');
const path = require('path');
const Web3 = require('web3');

const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8888'));

async function main() {
    let merchantContract_hx, userContract_hx;

    const MerchantContract_hx = require(path.resolve(__dirname, '../artifacts/contracts/MerchantContract_hx.sol/MerchantContract_hx.json'));
    const UserContract_hx = require(path.resolve(__dirname, '../artifacts/contracts/UserContract_hx.sol/UserContract_hx.json'));

    const accounts_hx = await web3.eth.getAccounts();

    // 部署 MerchantContract_hx
    merchantContract_hx = await new web3.eth.Contract(MerchantContract_hx.abi)
        .deploy({ data: MerchantContract_hx.bytecode })
        .send({ from: accounts_hx[0], gas: ' 7000000' });

    // 部署 UserContract_hx
    userContract_hx = await new web3.eth.Contract(UserContract_hx.abi)
        .deploy({ data: UserContract_hx.bytecode })
        .send({ from: accounts_hx[0], gas: '7000000' });

    // 设置 UserContract_hx 中的 MerchantContract_hx 地址
    await userContract_hx.methods.setMerchantContractAddress_hx(merchantContract_hx.options.address)
        .send({ from: accounts_hx[0], gas: ' 7000000' });

    // 构造只包含地址的数组
    const contractAddrArray_hx = [
        merchantContract_hx.options.address,
        userContract_hx.options.address
    ];

    // 将合约地址写入文件系统
    const addressFile_hx = path.resolve(__dirname, '../address_hx.json');
    fs.writeFileSync(addressFile_hx, JSON.stringify(contractAddrArray_hx, null, 2));

    console.log('地址写入成功:', contractAddrArray_hx);
}

main().catch((error_hx) => {
    console.error(error_hx);
    process.exitCode = 1;
});
