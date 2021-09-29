import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getOVOAdminAddress } from "./common";

export const deployFUSD = async () => {
	const OVOAdmin = await getOVOAdminAddress();
	await mintFlow(OVOAdmin, "10.0");

	return deployContractByName({ to: OVOAdmin, name: "FUSD" });
};

export const setupFUSDOnAccount = async (account) => {
	const name = "fusd/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};


export const getFUSDBalance = async (account) => {
	const name = "fusd/get_balance";
	const args = [account];

	return executeScript({ name, args });
};

/*
 * Mints **amount** of Kibble tokens and transfers them to recipient.
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to mint
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const mintFUSD = async (recipient, amount) => {
	const fusdAdmin = await getOVOAdminAddress();

	const name = "fusd/mint_tokens";
	const args = [recipient, amount];
	const signers = [fusdAdmin];

	return sendTransaction({ name, args, signers });
};

export const getTotalSupply = async () => {
	const name = "fusd/get_total_supply";

	return executeScript({ name });
};

/*
 * Transfers **amount** of Kibble tokens from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to transfer
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const transferFUSD = async (sender, recipient, amount) => {
	const name = "fusd/transfer_tokens";
	const args = [amount, recipient];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};
