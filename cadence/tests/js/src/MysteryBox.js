import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";

import { getOVOAdminAddress } from "./common";

// KittyItems types
export const typeID1 = 1000;

/*
 * Deploys NonFungibleToken and KittyItems contracts to KittyAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployMysteryBox = async () => {
	const OVOAdmin = await getOVOAdminAddress();
	await mintFlow(OVOAdmin, "10.0");

	return deployContractByName({ to: OVOAdmin, name: "MysteryBoxV2" });
};

/*
 * Setups KittyItems collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const getAccountDetail = async (account) => {
	const name = "mysterybox/get_account_detail";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns KittyItems supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getNyatheesOVOSupply = async () => {
	const name = "nft/get_total_supply";

	return executeScript({ name });
};

/*
 * Mints KittyItem of a specific **itemType** and sends it to **recipient**.
 * @param {UInt64} itemType - type of NFT to mint
 * @param {string} recipient - recipient account address
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const mintNyatheesOVO = async (itemType, recipient) => {
	const OVOAdmin = await getOVOAdminAddress();

	const name = "nft/mint_nft";
	const args = [recipient, itemType];
	const signers = [OVOAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers KittyItem NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferNyatheesOVO = async (sender, recipient, itemId) => {
	const name = "nft/transfer_nft";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the KittyItem NFT with the provided **id** from an account collection.
 * @param {string} account - account address
 * @param {UInt64} itemID - NFT id
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getAllTokenIds = async (account) => {
	const name = "nft/get_all_token";
	const args = [account];

	return executeScript({ name, args });
};

/*
 * Returns the number of Kitty Items in an account's collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
// export const getKittyItemCount = async (account) => {
// 	const name = "kittyItems/get_collection_length";
// 	const args = [account];

// 	return executeScript({ name, args });
// };
