pragma solidity 0.4.21;


library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


contract ERC20 {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract VRTMarket {
    using SafeMath for uint;
    
    uint public price;
    string public productName;
    
    address public tokenAddress;
    
    address public serviceAddress;
    uint public percentForService;
    
    address public owner;
    
    address[] holdersAddress;
    mapping (address => uint) holdersPercents;
    
    uint checkProcents;
    bool isRun;
    
    function VRTMarket(uint _price, string _productName, address _tokenAddress, address _serviceAddress, uint _percentForService, address[] _holders, uint[] _percents) public {
        owner = msg.sender;
        
        price = _price;
        productName = _productName;
        tokenAddress = _tokenAddress;
        
        serviceAddress = _serviceAddress;
        percentForService = _percentForService;
        
        for(uint i = 0; i < _holders.length; i++) {
            holdersAddress.push(_holders[i]);
            holdersPercents[_holders[i]] = _percents[i];
            checkProcents = checkProcents.add(_percents[i]);
        }
        
        require(checkProcents == 100);
    }

    function buyTheProduct() public {
        require(!isRun);
        require(ERC20(tokenAddress).transferFrom(msg.sender, this, price));
        
        uint tokensForServices = price.mul(percentForService).div(100);
        require(ERC20(tokenAddress).transfer(serviceAddress, tokensForServices));
        
        uint summary = price.sub(tokensForServices);
        for(uint i = 0; i < holdersAddress.length; i++) {
            uint result = summary.mul(holdersPercents[holdersAddress[i]]).div(100);
            require(ERC20(tokenAddress).transfer(holdersAddress[i], result));
        }
        
        owner = msg.sender;
        isRun = true;
    }
}
