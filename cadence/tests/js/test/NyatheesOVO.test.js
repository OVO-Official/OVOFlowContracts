import path from "path";

import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import { getOVOAdminAddress } from "../src/common";
import {
	deployNyatheesOVO,
	setupNyatheesOVOOnAccount,
	getNyatheesOVOSupply,
	mintNyatheesOVO,
	transferNyatheesOVO,
	getAllTokenIds,
	getNftItem
} from "../src/NyatheesOVO";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("NyatheesOVO", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7002;
		await init(basePath, { port });
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy NyatheesOVO contract", async () => {
		await shallPass(deployNyatheesOVO());
	});

	it("supply shall be 0 after contract is deployed", async () => {
		// Setup
		await deployNyatheesOVO();
		const OVOAdmin = await getOVOAdminAddress();
		await shallPass(setupNyatheesOVOOnAccount(OVOAdmin));

		await shallResolve(async () => {
			const supply = await getNyatheesOVOSupply();
			expect(supply).toBe(0);
		});
	});

	it("shall be able to mint a NyatheesOVO", async () => {
		// Setup
		await deployNyatheesOVO();
		const Alice = await getAccountAddress("Alice");
		await setupNyatheesOVOOnAccount(Alice);
        const args = {"time":"now"}

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintNyatheesOVO(args, Alice));
        await shallResolve(async () => {
			const supply = await getNyatheesOVOSupply();
			expect(supply).toBe(1);
		});
	});

    it("get tokenIds in NyatheesOVO", async () => {
		// Setup
		await deployNyatheesOVO();
		const Alice = await getAccountAddress("Alice");
		await setupNyatheesOVOOnAccount(Alice);
        const args = {"time":"now"}

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintNyatheesOVO(args, Alice));
        await shallPass(mintNyatheesOVO(args, Alice));
        await shallPass(mintNyatheesOVO(args, Alice));
       
        await shallResolve(async () => {
			const supply = await getNyatheesOVOSupply();
			expect(supply).toBe(3);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployNyatheesOVO();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupNyatheesOVOOnAccount(Alice);
		await setupNyatheesOVOOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		// await shallRevert(transferNyatheesOVO(Alice, Bob, 1337));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployNyatheesOVO();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupNyatheesOVOOnAccount(Alice);
		await setupNyatheesOVOOnAccount(Bob);
        const args = {"time":"now"}

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintNyatheesOVO(args, Alice));

		// Transfer transaction shall pass
		// await shallPass(transferNyatheesOVO(Alice, Bob, 0));
	});
});
