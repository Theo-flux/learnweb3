// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry {
    struct Student {
        string firstName;
        string lastName;
        uint256 age;
        uint256 height;
        string class;
        string dateOfBirth;
        uint256 regNo;
    }
}