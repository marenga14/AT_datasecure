// SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract secureDocument {
    /*STATE VARIABLES */
    address public i_owner;
    event ReturnContrctId(address from_sender, address contractId);
    event returnLoginStatus(bool status, address opadd);

    /*WHAT THE CONTRACT IS MEANT TO PERFORM*/

    //creating the struct to add all the OPERATORS in the system
    //Be able to map the documents and operators address
    // struct for all documents added in the system
    // provide prreveledge with respect to _type
    // verify documents against the hash value
    // mapp the document with respect to the sender
    //map document with respect to the receiver
    //return all the user
    //adding the operators
    //validate the operators

    /*listing and adding the organization*/
    struct Organizations {
        string orgName;
        address orgAddress;
        string[] members;
        string location;
    }

    Organizations[] organizationArray;

    /*mapping the address to organization */
    mapping(address => Organizations) public organizationAvailable;

    function isAvailable(address orgadd) public view returns (bool) {
        bool result = false;
        for (uint256 i; i < organizationArray.length; i++) {
            if (organizationArray[i].orgAddress == orgadd) {
                result = true;
                break;
            }
        }
        return result;
    }

    /* struct for operators*/
    struct Operator {
        string name;
        string organization;
        address userAddress;
        string position;
        Document[] documents;
    }

    /*create array of type operators*/

    Operator[] public operatorsArray;

    /* struct of documents/ currently */
    struct Document {
        string cidValue;
        address sender;
        string description;
        string docName;
        string time;
    }
    struct Users {
        address userAddres;
        string userType;
    }
    Users[] userArray;

    struct Shares {
        address sender;
        address receiver;
        string time;
        string comment;
    }

    struct docShares {
        string cidValue;
        Shares[] share;
    }

    /* creating array of documents */
    Document[] public documentArray;

    /* map the contracts and address */
    mapping(address => Operator) public operators;
    mapping(string => docShares) documentShares;
    mapping(string => Document) documentMapping;
    mapping(address => Users) public usersMapping;

    /* constructor to initialize the value to stay forever*/
    constructor() {
        i_owner = msg.sender;

        usersMapping[i_owner].userType = "admin";
    }

    /*method adding the institution*/
    function addOrganization(
        string memory name,
        address orgAdd,
        string memory location
    ) public ownerOnly {
        Organizations memory newOrg = Organizations({
            orgName: name,
            orgAddress: orgAdd,
            members: new string[](0),
            location: location
        });
        organizationArray.push(newOrg);

        Users memory newUser = Users({
            userAddres: orgAdd,
            userType: "institution"
        });

        userArray.push(newUser);
        usersMapping[orgAdd].userType = "institution";
    }

    /*retrievuing the organization from the blockchain*/

    /*mapping the address to organization */

    function testingAddress(address orgadd)
        public
        view
        returns (Organizations memory)
    {
        Organizations memory foundOrg;

        for (uint256 i; i < organizationArray.length; i++) {
            if (organizationArray[i].orgAddress == orgadd) {
                foundOrg = organizationArray[i];
            }
        }
        return foundOrg;
    }

    function getOrganization() public view returns (Organizations[] memory) {
        return organizationArray;
    }

    /* method to add operators */
    // Updated
    function addOperator(
        string memory _name,
        string memory _organization,
        address _userAddress,
        string memory _position
    ) public isIstitutionAdmin {

        operators[_userAddress].name = _name;
        operators[_userAddress].organization = _organization;
        operators[_userAddress].userAddress = _userAddress;
        operators[_userAddress].position = _position;


        operatorsArray.push(operators[_userAddress]);
        Users memory newUser = Users({
            userAddres: _userAddress,
            userType: "operator"
        });
        userArray.push(newUser);
        usersMapping[_userAddress].userType = "operator";
        // storeMembers.push(position);
    }

    /*view operators*/
    /*opr is supposed to be in the array*/
    function getOperators(string memory org)
        public
        view
        returns (Operator memory)
    {
        Operator memory opr;
        for (uint256 i; i < operatorsArray.length; i++) {
            if (
                keccak256(bytes(operatorsArray[i].organization)) ==
                keccak256(bytes(org))
            ) {
                opr = operatorsArray[i];
            }
        }
        return opr;
    }

    /* verify operators on login */

    function operatorLogin(address add) public view returns (string memory) {
        return usersMapping[add].userType;
    }

    /* verify operators on login  */

    function operatorFinder(address add)
        public
        view
        returns (Operator memory)
    {
        Operator memory val;

        for (uint256 i = 0; i < operatorsArray.length; i += 1) {
            if (add == operatorsArray[i].userAddress) {
                val = operatorsArray[i];
            }
        }
        return val;
    }

    function getAllOperators() public view returns (Operator[] memory) {
        return operatorsArray;
    }

    /* send the document by specify the the receiver address */
    // passing the address of the receiver
    // Updated
    function sendDocument(
        address _receiver,
        string memory _cidValue,
        string memory _time,
        string memory comment
    ) public returns (bool) {

        Document memory sharedDocument = documentMapping[_cidValue];

        // Check if receivers has a document already
        Document[] memory usersDocuments = operators[_receiver].documents;
        bool found = false;

        for (uint index = 0; index < usersDocuments.length; index++) {
            if (keccak256(bytes(_cidValue)) == keccak256(bytes(usersDocuments[index].cidValue))) {
                found = true;
                break;
            }
        }

        if (!found) operators[_receiver].documents.push(sharedDocument);
        documentShares[_cidValue].cidValue = _cidValue;
        documentShares[_cidValue].share.push(
            Shares(msg.sender, _receiver, _time, comment)
        );

        return true;
    }

    // Updated
    function storeDocument(
        string memory _cidValue,
        string memory _time,
        string memory comment,
        string memory _docName
    ) public returns (bool) {

        Document memory newDocument = Document({
            cidValue: _cidValue,
            sender: msg.sender,
            time: _time,
            description: comment,
            docName: _docName
        });
        documentArray.push(newDocument);
        documentMapping[_cidValue] = newDocument;

        operators[msg.sender].documents.push(newDocument);
        return true;
    }

    // receive the document
    // function receivedDocs() public view returns (Document[] memory) {
    //     uint256 arrayLength = documentArray.length;
    //     Document[] memory foundDocArray = new Document[](arrayLength);

    //     string[] memory doc = operators[msg.sender].documents;
    //     for (uint256 i; i < doc.length; i++) {
    //         for (uint256 j; j < documentArray.length; j++) {
    //             if (
    //                 keccak256(bytes(documentArray[j].cidValue)) ==
    //                 keccak256(bytes(doc[i]))
    //             ) {
    //                 foundDocArray[j] = documentArray[j];
    //             }
    //         }
    //     }

    //     return foundDocArray;
    // }


    /* verifying document */
    mapping(string => Document) public foundDoc;

    function verifyDocument(string memory _cid) public view returns (bool) {
        bool val;
        for (uint256 i; i < documentArray.length; i++) {
            if (
                keccak256(bytes(documentArray[i].cidValue)) ==
                keccak256(bytes(_cid))
            ) {
                val = true;
            } else {
                val = false;
            }
        }
        return val;
    }

    /*MODIFIERS */
    modifier ownerOnly() {
        require(msg.sender == i_owner, "Admin Account is required");
        _;
    }

    modifier RegisteredUser() {
        for (uint256 i = 0; i < operatorsArray.length; i += 1) {
            if (msg.sender == operatorsArray[i].userAddress) {
                _;
            }
        }
    }

    // Updated
    modifier isIstitutionAdmin() {
        bool isAdmin = false;
        for (uint256 i = 0; i < organizationArray.length; i += 1) {
            if (msg.sender == organizationArray[i].orgAddress) {
                isAdmin = true;
            }
        }
        require(isAdmin, "Institution Admin account is required");
        _;
    }

    /* INDIRECT METHODS

/* Testing function to retrieving operators */
    function getOperatorss(uint256 index)
        public
        view
        returns (Operator memory)
    {
        return operatorsArray[index];
    }

    /*testing function to view the documents in the addresses */
    function getDocuments(address userAddress)
        public
        view
        returns (Document[] memory)
    {
        return operators[userAddress].documents;
    }

    /*checking the documents in the document array*/
    function presenceChecker(string memory hashedDoc)
        public
        view
        returns (bool)
    {
        bool val;
        for (uint256 i; i < documentArray.length; i += 1) {
            //keccak256(bytes(a)) == keccak256(bytes(b)); = using this when comparing string literals

            if (
                keccak256(bytes(hashedDoc)) ==
                keccak256(bytes(documentArray[i].cidValue))
            ) {
                val = true;
            } else {
                val = false;
            }
        }

        return val;
    }

    // function areStringsEqual(string memory first_string, string memory second_string) internal pure returns (bool)
    // {
    //      if (
    //             keccak256(bytes(first_string)) ==
    //             keccak256(bytes(second_string))
    //         ) {
    //             return true;
    //         } else {
    //             return false;
    //         }
    // }

    /*checking the documents shares */
    function getShares(string memory _cidValue)
        public
        view
        returns (Shares[] memory)
    {
        Shares[] memory docShare = documentShares[_cidValue].share;
        return docShare;
    }
}
