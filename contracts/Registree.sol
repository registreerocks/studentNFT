pragma solidity ^0.5.2;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Registree is Ownable {

    struct Student {
        string identifyingID;
        string identifyingURL;
    }

    modifier onlyStudent(bytes32 _id) {
        require(NftOwner[_id] == msg.sender, "Sender unauthorized");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Sender unauthorized");
        _;
    }

    modifier onlyStudentOrAdmin(bytes32 _id) {
        require(NftOwner[_id] == msg.sender || NftAdmin[_id] == msg.sender, "Sender unauthorized");
        _;
    }

    mapping (bytes32 => Student) public students;
    mapping (bytes32 => address) public NftOwner;
    mapping (address => bytes32) public ownerNft;
    mapping (bytes32 => bool) public queriability;
    mapping (bytes32 => address) public NftAdmin;
    mapping (address => bool) public admins;

    function registerAdmin(address _address) external onlyOwner{
        admins[_address] = true;
    }

    function createStudent(bytes32 _id, string calldata _identId, string calldata _identUrl, address _student) external onlyAdmin {
        students[_id] = Student(_identId, _identUrl);
        NftOwner[_id] = _student;
        ownerNft[_student] = _id;
        queriability[_id] = true;
        NftAdmin[_id] = msg.sender;
    }

    function transfer(bytes32 _id, address _newOwner) external onlyStudent(_id) {
        NftOwner[_id] = _newOwner;
    }

    function toggleQueriability(bytes32 _id) external onlyStudent(_id) {
        if (queriability[_id]) {
            queriability[_id] = false;
        } else {
            queriability[_id] = true;
        }
    }

    function updateIdentifyingId(bytes32 _id, string calldata _identId) external onlyStudentOrAdmin(_id) {
        students[_id].identifyingID = _identId;
    }

}