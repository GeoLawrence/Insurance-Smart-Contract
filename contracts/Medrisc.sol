pragma solidity ^0.4.15;

contract Medrisc {

    address pool = 0x0688e33eFe506Bb0D7654DF7803F72B44AEf140d;

    struct ClientData {
        bool banned;
        bool policyValid;
        uint256 lastPayment;
        uint256 bill;
        uint256 amount;
    }

    mapping(address => ClientData) public clients;

    uint256 public paymentPeriod = 30 days;

    function underwrite() public payable {      // receives payment and adds to policy

        require(msg.value > 1 ether);

        pool.call.value(msg.value);

        ClientData storage customer = clients[msg.sender];

        customer.lastPayment = now;
        customer.policyValid = true;

    }

    function update(address patient) public {

        ClientData storage customer = clients[patient];

        if (customer.policyValid && customer.lastPayment + paymentPeriod < now) {
            customer.policyValid = false;
            customer.banned = true;
        }
    }

    function isInsured(address patient) public constant returns (bool insured) {

        ClientData storage customer = clients[patient];

        return customer.policyValid &&
            !customer.banned &&
            customer.lastPayment + paymentPeriod >= now;

    }

    function getClaim(address patient) constant public returns (uint256 premium) {

      ClientData storage customer = clients[patient];

      if ((customer.amount) > 150000) {
          return 150000;
      }
      else {
          return customer.amount;
      }
    }

    function claim(address patient) public payable {

        ClientData storage customer = clients[patient];
        require(isInsured(patient) && customer.policyValid && !customer.banned);
        patient.send(getClaim(patient));
        customer.lastPayment = now;
        update(patient);
    }

    function verified(address patient, uint bill_no, uint verAmount) public restricted {

        ClientData storage customer = clients[patient];

        customer.bill = bill_no;
        customer.amount = verAmount ;
    }

    modifier restricted {
        require(msg.sender == pool);
        _;
    }

//    function() public payable {
//    }
}
