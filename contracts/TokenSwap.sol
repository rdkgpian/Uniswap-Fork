pragma solidity >0.7.0;


//import the ERC20 interface

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


//import the uniswap router
//the contract needs to use swapExactTokensForTokens
//this will allow us to import swapExactTokensForTokens into our contract

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
  
  function swapExactTokensForTokens(
  
    //amount of tokens we are sending in
    uint256 amountIn,
    //the minimum amount of tokens we want out of the trade
    uint256 amountOutMin,
    //list of token addresses we are going to trade in.  this is necessary to calculate amounts
    address[] calldata path,
    //this is the address we are going to send the output tokens to
    address to,
    //the last time that the trade is valid for
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  function factory() external pure returns (address);

function addLiquidity(
  address tokenA,
  address tokenB,
  uint amountADesired,
  uint amountBDesired,
  uint amountAMin,
  uint amountBMin,
  address to,
  uint deadline
) external returns (uint amountA, uint amountB, uint liquidity);}

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function swap(
    uint256 amount0Out,
    uint256 amount1Out,
    address to,
    bytes calldata data
  ) external;
  function kLast() external view returns (uint);
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IUniswapV2Factory {
  function getPair(address token0, address token1) external returns (address);
  function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract TokenSwap {
    
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    //address private tokenIn;
    //address private tokenOut;
    //address private constant UniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private  UniswapFactory;
    address private UniswapPair;
      address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
      event Reserves (uint112 _reserve0, uint112 _reserve1);
	  event	AddLiquidity(uint amountA, uint amountB, uint liquidity);
    function setFactoryAddress() external returns(address){

        require(UNISWAP_V2_ROUTER!=address(0), "Set Router address first");
        UniswapFactory = IUniswapV2Router(UNISWAP_V2_ROUTER).factory();
        return UniswapFactory;
    }

    function getPairAddress(address _tokenA, address _tokenB) external returns(address) {

        UniswapPair = IUniswapV2Factory(UniswapFactory).getPair(_tokenA, _tokenB);
        if(UniswapPair == address(0)) {
            UniswapPair = IUniswapV2Factory(UniswapFactory).createPair(_tokenA, _tokenB);
        }

        return UniswapPair;
    }

    function getReserves() external returns (uint112, uint112) {

        require(UniswapPair!= address(0), "Create Pair first");
        (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(UniswapPair).getReserves();

        emit Reserves(_reserve0, _reserve1);
        return (_reserve0, _reserve1);
        
    }

    function getK() external view returns (uint) {

        require(UniswapPair!= address(0), "Create Pair first");
        return IUniswapV2Pair(UniswapPair).kLast();
    }

    function swap(address _tokenA, address _tokenB, uint256 _amountIn, uint256 _amountOutMin, address _to) external {
      
    //first we need to transfer the amount in tokens from the msg.sender to this contract
    //this contract will have the amount of in tokens
    IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountIn);
    
    //next we need to allow the uniswapv2 router to spend the token we just sent to this contract
    //by calling IERC20 approve you allow the uniswap contract to spend the tokens in this contract 
    IERC20(_tokenA).approve(UNISWAP_V2_ROUTER, _amountIn);

    //path is an array of addresses.
    
    address[] memory path;
    path = new address[](2);
    path[0] = _tokenA;
    path[1] = _tokenB;
    
        //then we will call swapExactTokensForTokens
        //for the deadline we will pass in block.timestamp
        //the deadline is the latest time the trade is valid for
    IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);
    }

    function getAmountOutMin(address _tokenA, address _tokenB, uint256 _amountIn) external view returns (uint256) {

      
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenA;
        path[1] = _tokenB;
     
        uint256[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);
        return amountOutMins[path.length -1];  
    }  

    function addLiquidity(address _tokenA, address _tokenB, uint256 _amountA, uint256 _amountB) external returns(uint, uint, uint) {

    	IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
    	IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

    	IERC20(_tokenA).approve(UNISWAP_V2_ROUTER, _amountA);
    	IERC20(_tokenB).approve(UNISWAP_V2_ROUTER, _amountB);

    	(uint amountA, uint amountB, uint liquidity) = IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidity(_tokenA, _tokenB, _amountA, _amountB, 1, 1, address(this), block.timestamp);
    	
    	 emit AddLiquidity(amountA, amountB, liquidity);
    	return (amountA, amountB, liquidity);

  
    }

}


