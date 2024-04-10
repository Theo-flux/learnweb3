// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry {
    address owner;
    struct Student {
        uint256 regNo;
        address walletAddress;
        string firstName;
        string lastName;
        string avatar;
        uint256 age;
        uint256 height;
        string class;
        string dateOfBirth;
        string gender;
    }
    uint256 noOfStudents;

    mapping(uint256 => Student) public students;

    // my events.
    event studentAdded(uint256 regNo);
    event studentDeleted(uint256 regNo);

    constructor() {
        owner = msg.sender;
    }

    // my admin access modifier. 
    modifier onlyOwner() {
        require(owner == msg.sender, 'You do not have admin access.');
        _;
    }

    // valid regNo modifier
    modifier isRegValid(uint256 regNo) {
        require(students[regNo].regNo != 0, "Invalid student reg no.");
        _;
    }

    // function to add a student on-chain.
    function addStudent(
        uint256 regNo,
        address walletAddress,
        string memory firstName,
        string memory lastName,
        string memory avatar,
        string memory class,
        string memory dateOfBirth,
        string memory gender,
        uint256 age,
        uint256 height
    ) public onlyOwner {
        // add student.
        Student memory newStudentData = Student(
            regNo,
            walletAddress,
            firstName,
            lastName,
            avatar,
            age,
            height,
            class,
            dateOfBirth,
            gender
        );
        students[regNo] = newStudentData;
        noOfStudents += 1;

        // emit add event.
        emit studentAdded(regNo);
    }

    // function to delete a student on-chain.
    function removeStudent(uint256 regNo) public onlyOwner isRegValid(regNo) {
        // delete student.
        delete students[regNo];
        noOfStudents -= 1;

        // emit delete event.
        emit studentDeleted(regNo);
    }

    // Function to edit student data on-chain.
    function editStudent(
        uint256 regNo,
        address walletAddress,
        string memory firstName,
        string memory lastName,
        string memory avatar,
        string memory class,
        string memory dateOfBirth,
        string memory gender,
        uint256 age,
        uint256 height
    ) public onlyOwner isRegValid(regNo) {
        // Update the student's data with the new values.
        Student storage studentToUpdate = students[regNo];
        if (walletAddress != address(0)) {
            studentToUpdate.walletAddress = walletAddress;
        }
        if (bytes(firstName).length > 0) {
            studentToUpdate.firstName = firstName;
        }
        if (bytes(lastName).length > 0) {
            studentToUpdate.lastName = lastName;
        }
        if (bytes(avatar).length > 0) {
            studentToUpdate.avatar = avatar;
        }
        if (bytes(class).length > 0) {
            studentToUpdate.class = class;
        }
        if (bytes(dateOfBirth).length > 0) {
            studentToUpdate.dateOfBirth = dateOfBirth;
        }
        if (bytes(gender).length > 0) {
            studentToUpdate.gender = gender;
        }
        if (age > 0) {
            studentToUpdate.age = age;
        }
        if (height > 0) {
            studentToUpdate.height = height;
        }
    }

    // function to get student by regNo from on-chain.
    function getStudentByRegNo(uint256 regNo) public view isRegValid(regNo) returns(Student memory) {
        return students[regNo];
    }

    // Function to return all students with pagination
    function getAllStudents(uint256 limit, uint256 offset) public view returns (Student[] memory) {
        // Set default value for limit if not provided
        if (limit == 0) {
            limit = 10;
        }

        require(limit > 0, "Limit must be greater than zero.");
        require(offset >= 0, "Offset must be non-negative.");

        uint256 startIndex = offset * limit + 1;
        uint256 endIndex = startIndex + limit - 1;

        if (endIndex > noOfStudents) {
            endIndex = noOfStudents;
        }

        // Create an array to store students
        Student[] memory result = new Student[](endIndex - startIndex + 1);

        // Populate the array with student data
        for (uint256 i = startIndex; i <= endIndex; i++) {
            result[i - startIndex] = students[i];
        }

        return result;
    }
}
