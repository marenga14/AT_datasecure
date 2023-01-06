/** @format */

//import
//main function
//calling the main function

// const address = "0xDE6AA745D81dfE09e14f39471C8A27509c9169Ed";
module.exports.default = async ({ getNamedAccounts, deployments }) => {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const chainId = network.config.chainId;
	console.log(chainId);
	const doc = await deploy("secureDocument", {
		from: deployer,
		args: [],
		log: true,
	});
};
