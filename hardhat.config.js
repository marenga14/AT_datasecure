/** @format */

require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
// require("@nomiclabs/hardhat-waffle")
console.log(process.env.PRIVATE_KEY)

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.7",
	networks: {
		ganache: {
			url: "https://rpc.all.co.tz/",
			chainId:19611009,
			accounts: [process.env.PRIVATE_KEY],
		},
	},
  namedAccounts: {
    deployer: {
        default: 0, // here this will by default take the first account as deployer
        1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
  }
};
