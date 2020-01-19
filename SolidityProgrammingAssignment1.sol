pragma solidity ^0.5.0;

contract StudentEnrollment{
    address private myAddress = address(this);
    address owner;
    uint totalStudents;
    
    enum Degree{
        Matric,
        Inter,
        BS,
        MS,
        PhD
    }
    
    enum Gender{
        Male,
        Female
    }
    
    enum Program{
        ArtificialIntelligence,
        InternetOfThings,
        CloudNativeComputing,
        Blockchain,
        QuantumComputing
    }
    
    enum Class{
        OnSite,
        Online
    }
    
    mapping (string => string) studentLink;
    mapping (string => studentDetails) studentData;
    
    struct studentDetails{
        bool record;
        string studentName;
        uint studentAge;
        address payable studentAddress;
        Degree studentDegree;
        Gender studentGender;
        Program studentProgram;
        Class studentClass;
        string studentRollNumber;
    }
    
    modifier checkBalance{
        require(msg.value >= 2 ether, "You need 2 Ether to enroll - Neither more nor less");
        _;
    }
    
    modifier checkOwner{
        require(msg.sender == owner, "You do not have permission to execute this function");
        _;
    }
    
    modifier checkData(string memory studentRollNumber, string memory studentName, uint studentAge){
        require(msg.value == 2 ether);
        require(bytes(studentRollNumber).length != 0, "Student Roll Number cannot be left empty");
        require(bytes(studentLink[studentRollNumber]).length == 0, "A Student has already registered with the following Roll Number");
        require(bytes(studentName).length != 0, "Student Name cannot be left empty");
        require(studentAge >= 15, "Student Age  cannot be < 15");
        _;
    }
    
    constructor() public{
        owner = msg.sender;
    }
    
    function enrollStudent(string memory studentName, uint studentAge, Degree studentDegree, Gender studentGender, Program studentProgram, Class studentClass, string memory studentRollNumber) public payable checkBalance checkData(studentRollNumber, studentName, studentAge) returns(bool){
        studentDetails memory newStudent = studentDetails(true, studentName, studentAge, msg.sender, studentDegree, studentGender, studentProgram, studentClass, studentRollNumber);
        totalStudents++;
        studentLink[studentRollNumber] = studentName;
        studentData[studentName] = newStudent;
        return true;
    }
    
    function numberOfStudents() public view checkOwner returns(uint){
        return totalStudents;
    }
    
    function amountCollected() public view checkOwner returns(uint){
        return myAddress.balance;
    }
    
    function isBSPassed(string memory studentName) public view checkOwner returns(bool, Degree){
        Degree cDeg = studentData[studentName].studentDegree;
        if(uint(cDeg) > 1)
        {
            return (true, cDeg);
        }
    }
}