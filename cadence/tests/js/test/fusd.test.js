import path from "path";

import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import { toUFix64, getOVOAdminAddress } from "../src/common";

import {
	deployFUSD,
	setupFUSDOnAccount,
	getFUSDBalance,
	mintFUSD,
	transferFUSD,
	getTotalSupply
} from "../src/fusd";

jest.setTimeout(500000);

describe("Kibble", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7001;
		await init(basePath, { port });
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall have initialized supply field correctly", async () => {
		// Deploy contract
		await shallPass(deployFUSD());

		await shallResolve(async () => {
			const supply = await getTotalSupply();
			expect(supply).toBe(toUFix64(0));
		});
	});

	it("shall be able to create empty Vault that doesn't affect supply", async () => {
		// Setup
		await deployFUSD();
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupFUSDOnAccount(Alice));
		await shallResolve(async () => {
			const aliceBalance = await getFUSDBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(0));
		});
	});

	it("shall not be able to mint zero tokens", async () => {
		// Setup
		await deployFUSD();
		const Alice = await getAccountAddress("Alice");
		await setupFUSDOnAccount(Alice);

		// Mint instruction with amount equal to 0 shall be reverted
		await shallRevert(mintFUSD(Alice, toUFix64(0)));
	});

	it("shall mint tokens, deposit, and update balance and total supply", async () => {
		// Setup
		await deployFUSD();
		const Alice = await getAccountAddress("Alice");
		await setupFUSDOnAccount(Alice);
		const amount = toUFix64(50);

		// Mint Kibble tokens for Alice
		await shallPass(mintFUSD(Alice, amount));

		// Check Kibble total supply and Alice's balance
		await shallResolve(async () => {
			// Check Alice balance to equal amount
			const balance = await getFUSDBalance(Alice);
			expect(balance).toBe(amount);

			// Check Kibble supply to equal amount
			const supply = await getTotalSupply();
			expect(supply).toBe(amount);
		});
	});

	it("shall not be able to withdraw more than the balance of the Vault", async () => {
		// Setup
		await deployFUSD();
		const OVOAdmin = await getOVOAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupFUSDOnAccount(OVOAdmin);
		await setupFUSDOnAccount(Alice);

		// Set amounts
		const amount = toUFix64(1000);
		const overflowAmount = toUFix64(30000);

		// Mint instruction shall resolve
		await shallResolve(mintFUSD(OVOAdmin, amount));

		// Transaction shall revert
		await shallRevert(transferFUSD(OVOAdmin, Alice, overflowAmount));

		// Balances shall be intact
		await shallResolve(async () => {
			const aliceBalance = await getFUSDBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(0));

			const OVOAdminBalance = await getFUSDBalance(OVOAdmin);
			expect(OVOAdminBalance).toBe(amount);
		});
	});

	it("shall be able to withdraw and deposit tokens from a Vault", async () => {
		await deployFUSD();
		const OVOAdmin = await getOVOAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupFUSDOnAccount(OVOAdmin);
		await setupFUSDOnAccount(Alice);
		await mintFUSD(OVOAdmin, toUFix64(1000));

		await shallPass(transferFUSD(OVOAdmin, Alice, toUFix64(300)));

		await shallResolve(async () => {
			// Balances shall be updated
			const OVOAdminBalance = await getFUSDBalance(OVOAdmin);
			expect(OVOAdminBalance).toBe(toUFix64(700));

			const aliceBalance = await getFUSDBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(300));

			const supply = await getTotalSupply();
			expect(supply).toBe(toUFix64(1000));
		});
	});



    }

	
)