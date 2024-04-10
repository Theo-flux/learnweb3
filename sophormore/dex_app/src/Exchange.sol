// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.24;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Exchange is ERC20 {
    address public tokenAddress;
    // Exchange is inheriting ERC20, because our exchange itself is an ERC-20 contract
    // as it is responsible for minting and issuing LP Tokens

    constructor(address _tokenAddress) ERC20('ETH Liquidity Provider Token', 'LPETH'){
        require(_tokenAddress != address(0), 'Token address passed is a null address.');
        tokenAddress = _tokenAddress;
    }

    // getReserve returns the balance of `token` held by `this` contract
    function getReserve() view public returns(uint256) {
        return ERC20(tokenAddress).balanceOf(address(this));
    }

    // addLiquidity allows users to add liquidity to the exchange pool
    function addLiquidity(uint256 amtToken) public payable returns(uint256) {
        uint256 lpTokensToMint;
        uint256 ethReserveBalance = address(this).balance;
        uint256 tokenReserveBalance = getReserve();

        ERC20 token = ERC20(tokenAddress);

        // If the reserve is empty, take any user supplied value for initial liquidity (if you are the  first)
        if(tokenReserveBalance == 0) {
            // Transfer the token from the user to the exchange
            token.transferFrom(msg.sender, address(this), amtToken);

            // lpTokensToMint = ethReserveBalance = msg.value
            lpTokensToMint = ethReserveBalance;

            // Mint lp tokens to the user
            _mint(msg.sender, lpTokensToMint);

            return lpTokensToMint;
        }

        // If the reserve is not empty, calculate the amount of LP Tokens to be minted (if you are not the first)
        uint256 ethReservePriorToFuncCall = ethReserveBalance - msg.value;
        uint256 minTokenRequired = (msg.value * tokenReserveBalance) / ethReservePriorToFuncCall;

        require(amtToken >= minTokenRequired, "Insufficient amount of tokens provided.");
        token.transferFrom(msg.sender, address(this), minTokenRequired);

        // Calculate the amount of LP tokens to be minted
        lpTokensToMint = (totalSupply() * msg.value) / ethReservePriorToFuncCall;
        
        // Mint lp tokens to the user
        _mint(msg.sender, lpTokensToMint);

        return lpTokensToMint;
    }
    

    // removeLiquidity allows users to remove liquidity from the exchange
    function removeLiquidity(uint256 amtOfLpTokens) public returns(uint256, uint256){
        // check that the amount of LP to be removed is greater than zero
        require(amtOfLpTokens > 0, 'Amount of Lp to remove must be greater than zero.');

        uint256 ethReserveBalance = address(this).balance;
        uint256 lpTokenTotalSupply = totalSupply();

        // calculate the amount of eth and token to return to user
        uint256 ethToReturn = (ethReserveBalance * amtOfLpTokens) / lpTokenTotalSupply;
        uint256 tokenToReturn = (getReserve() * amtOfLpTokens) / lpTokenTotalSupply;

        // burn the lp tokens from the user, and transfer the eth and token to the user.
        _burn(msg.sender, amtOfLpTokens);
        payable(msg.sender).transfer(ethToReturn);
        ERC20(tokenAddress).transfer(msg.sender, tokenToReturn);

        return (ethToReturn, tokenToReturn);
    }

    // getOutputAmountFromSwap calculates the amount of output tokens to be received based on xy = (x + dx)(y - dy)
    function getOutputAmtFromSwap(uint256 inputAmt, uint256 inputReserve, uint256 outputReserve) public pure returns(uint256){
        require(inputReserve > 0 && outputReserve > 0, "Reserves must be greater than zero.");
    
        uint256 inputAmtWithFee = inputAmt * 99;
        uint256 numerator = (outputReserve * inputAmtWithFee);
        uint256 denominator = ((inputReserve * 100) + inputAmtWithFee);

        return numerator / denominator;
    }

    // ethToTokenSwap allows users to swap ETH for tokens
    function ethToTokenSwap(uint256 minTokenToReceive) public payable {
        uint256 tokenReserveBalance = getReserve();
        uint256 tokensToReceive = getOutputAmtFromSwap(msg.value, address(this).balance - msg.value, tokenReserveBalance);

        require(tokensToReceive >= minTokenToReceive, "Tokens received is less than minimun token expected.");
        ERC20(tokenAddress).transfer(msg.sender, tokensToReceive);
    }


    // tokensToEthSwap allows users to swap tokens for ETH
    function tokenToEthSwap(uint256 tokensToSwap, uint256 minEthToReceive) public {
        uint256 tokenReserveBalance = getReserve();
        uint256 ethToReceive = getOutputAmtFromSwap(tokensToSwap, tokenReserveBalance,address(this).balance);
        require(ethToReceive >= minEthToReceive, "ETH received is less than minimum ETH expected");

        ERC20(tokenAddress).transferFrom(msg.sender, address(this), tokensToSwap);

        payable(msg.sender).transfer(ethToReceive);
    }
}