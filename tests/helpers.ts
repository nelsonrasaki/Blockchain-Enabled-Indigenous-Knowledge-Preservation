// Mock helpers for Clarity testing

export function mockClarityBlockInfo(height = 100) {
	// Mock block info for testing
	global.blockHeight = height;
	global.blockTime = Math.floor(Date.now() / 1000);
}

export function mockClarityBitcoin() {
	// Mock Bitcoin-related functions
	global.btcBlockHeight = 700000;
	global.btcBlockHeader = Buffer.from('0000000000000000000000000000000000000000000000000000000000000000', 'hex');
}
