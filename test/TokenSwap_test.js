const TokenSwap = artifacts.require("TokenSwap");
const { sendEther, pow } = require("./util");
const BN = require("bn.js");
const truffleAssert = require('truffle-assertions');
const IERC20 = artifacts.require("IERC20");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */

 //Adding Startingnode 1
contract("TokenSwap", (accounts) => {
   let instance;
   let tokenA;
   let tokenB;
   let acc = "0xd76B4f515756a70fc4D14d7eD8218e653a22eE7E";
   let tokenAAddress = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709";
   let tokenBAddress = "0xddea378A6dDC8AfeC82C36E9b0078826bf9e68B6";
   const TOKEN_A_AMOUNT = pow(10,19);
   const TOKEN_B_AMOUNT = pow(10,19);

   beforeEach('should setup the contract instance', async () => {
    instance = await TokenSwap.deployed();
    tokenA = await IERC20.at(tokenAAddress);
    tokenB = await IERC20.at(tokenBAddress);

    await tokenA.approve(instance.address, TOKEN_A_AMOUNT, {from: acc});
    await tokenB.approve(instance.address, TOKEN_B_AMOUNT, {from: acc});
  });
  

 /* it("Setting Router Address", async() =>{
  	let address = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
    await instance.setRouterAddress(address,{from:acc});

  });*/
 it("Token A Balance", async() =>{

    const result= await tokenA.balanceOf(acc,{from:acc});
    console.log("Token A Balance" , result.toString());

  });

 it("Token B Balance", async() =>{

    const result= await tokenB.balanceOf(acc,{from:acc});
    console.log("Token B Balance" , result.toString());

  });


 it("Setting Factory Address", async() =>{

    const result= await instance.setFactoryAddress({from:acc});
   // console.log("Factory Address" , result.toString());

  });

	it("Getting Pair Address", async() =>{
  		
    	const result= await instance.getPairAddress(tokenAAddress, tokenBAddress,{from:acc});
    //	console.log("Pair Address",  result);

  });

 /* it("Adding Liquidity", async() =>{

      let result= await instance.addLiquidity(tokenAAddress, tokenBAddress, pow(10,15), pow(10,16) ,{from:acc});
      console.log(" == add liquidity == ");
 
    
      truffleAssert.eventEmitted(result, 'AddLiquidity', (event) =>{
      console.log(event);
    });

  });*/


  it("Getting Reserves", async() =>{
      
      const result= await instance.getReserves({from:acc});
     // var r1 = result[0].toString();
    //  var r2 = result[1].toString();
    //  console.log("Amt A" , r1);
    //  console.log("Amt B", r2); 
      //console.log("LT" , result.liquidity.toString());
  });

  it("Getting K", async() =>{
      
      const result= await instance.getK({from:acc});
      console.log("K" , result.toString());

  });

    it("Getting Min token amount out", async() =>{

      const result= await instance.getAmountOutMin(tokenAAddress, tokenBAddress,pow(10,19),{from:acc});
      console.log("Amount out min" , result.toString());

  });

    it("Swapping tokens", async() =>{

      const TOKEN_IN = pow(10,15);
      const TOKEN_OUT_MIN = 1;
      const result= await instance.swap(tokenAAddress, tokenBAddress,TOKEN_IN,pow(10,20),acc,{from:acc});
     // console.log("Amount out min" , result.toString());

  });

     it("Token A Balance", async() =>{

    const result= await tokenA.balanceOf(acc,{from:acc});
    console.log("Token A Balance" , result.toString());

  });

 it("Token B Balance", async() =>{

    const result= await tokenB.balanceOf(acc,{from:acc});
    console.log("Token B Balance" , result.toString());

  });

 it("Getting Reserves", async() =>{
      
      const result= await instance.getReserves({from:acc});
     // var r1 = result[0].toString();
    //  var r2 = result[1].toString();
    //  console.log("Amt A" , r1);
    //  console.log("Amt B", r2); 
      //console.log("LT" , result.liquidity.toString());
  });

  it("Getting K", async() =>{
      
      const result= await instance.getK({from:acc});
      console.log("K" , result.toString());

  });

});

