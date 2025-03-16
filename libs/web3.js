// web3.js

import Web3 from "web3";

// 浏览器环境且已经安装了 Metamask
if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  window.web3js = new Web3(window.web3.currentProvider);
  console.log("装了metamask");
  // 服务器环境或者没有安装 Metamask, ,https://rinkeby.infura.io/CqCd0QgCozHBEk19ub2M
} else {
  window.web3js = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8888'));
  console.log("没有装metamask");
}

window.Web3 = Web3;
