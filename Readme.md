## Demonstration FlashSwap On Uniswap

An example of quering token prices and swaping token on uniswap. 

### 1. Install Dependencies
```
$ npm install
```

### 2. Compile Contract
```
$ npx hardhat compile
```

### 3. Test Contract
```
$ npx hardhat test
```

### 4. Using Contract

#### a. Flash Query
        Deploy contract to EVM based chain then find the uniswap like protocol factory address. 

        ```
            require('dotenv').config();

            const { BigNumber, Wallet, Contract, providers, utils } = require( "ethers" );

            const provider = new providers.StaticJsonRpcProvider(process.env.RPC_URL);

            const queryContract = new Contract(FLASHQUERY_CONTRACT_ADDRESS, FLASHQUERY_CONTRACT_ABI, provider); 

            // get reserves for each pairs to calculate token price
             
            const pairs  = (await queryContract.functions.getPairs("UNISWAP_FACTORY_ADDRESS", 0, 10))[0]; 
            const reserves  = (await queryContract.functions.getReservesByPairs(pairs))[0]; 
            
            const combined = pairs.map((i, j) => {  
                    return { 
                        pairAddress: pairs[j],
                        reserve0: reserves[j][0], 
                        reserve1: reserves[j][1], 
                        lastBlockTs: reserves[j][2]
                    } 

            const amountIn = 1; // token amount to sell 
            const buyPrice = getAmountOut(combined[0].reserve0, combined[0].reserve1, 1, 997);

        ```
#### a. Flash Swap


### 5. Calculation Token Price 
You can calculate token buy/sell price by the following code. 

```
function getAmountIn(reserveIn, reserveOut, amountOut, exchangeFee) {
    const numerator = reserveIn.mul(amountOut).mul(10000);
    const denominator = reserveOut.sub(amountOut).mul(exchangeFee);
    return numerator.div(denominator).add(1);
}

function getAmountOut(reserveIn, reserveOut, amountIn, exchangeFee) {
    const amountInWithFee = amountIn.mul(exchangeFee);
    const numerator = amountInWithFee.mul(reserveOut);
    const denominator = reserveIn.mul(10000).add(amountInWithFee);
    return numerator.div(denominator);
}
```
