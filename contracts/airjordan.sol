pragma solidity ^0.8.7;

contract JordanSneakerOrder {
	// Step 1: Creating the contract's owner address
 	address payable public ownerAddress;
	
	// Step 2: Creating the customer's address
	address public customerAddress;

    // Step 3: Structuring the invoices to link to orders
	struct Invoice {
		uint ID;		
		uint orderNo;		
		bool created;
	}
	
	// Step 4: Structuring the orders for the sneakers based on price, quantity, order and delivery date
	struct Order {
		uint ID;
		string JordanSneaker;
		uint quantity;		
		uint price;
		uint safePay;
		uint dateOfOrder;
		uint dateOfDelivery;
		bool created;			
	}

    // Step 5: Mapping
	// Mapping for orders to have an list for each of the orders
	mapping (uint => Order) orders;
	// Mapping for invoices to have an list for each of the invoices
	mapping (uint => Invoice) invoices;
    // Index value of the orders
	uint orderseq;
	// Index value of the invoices
	uint invoiceseq;
	
	// Step 6: JordanSneakerOrder constructor
	constructor(address _buyAddr) public payable {
        ownerAddress = payable(msg.sender);

		customerAddress = _buyAddr;
	}

	// Step 7: Creating a function to send an order
	function sendOrder(string memory JordanSneaker, uint quantity) payable public {				
		// Now only the customer can use this function
		require(msg.sender == customerAddress);
		// Increasing the order index
		orderseq++;
		// Creating the order
		orders[orderseq] = Order(orderseq, JordanSneaker, quantity, 0, 0, 0, 0, true);
	}

	// Step 8: Creating a function to check orders
	function checkOrder(uint ID) view public returns (address customer, string memory JordanSneaker, 
    uint quantity, uint price, uint safePay) {		
		// We need to check if the order exists
		require(orders[ID].created);
		// Returning the order
		return(customerAddress, orders[ID].JordanSneaker, 
		orders[ID].quantity, orders[ID].price, orders[ID].safePay);
	}

	// Step 9: Creating a function to send a safe payment
	function sendSafePayment(uint orderNo) payable public {
		// Now only the customer can use this function
		require(customerAddress == msg.sender);
		// We need to check if the order exists
		require(orders[orderNo].created);			
		// Payout
		orders[orderNo].safePay = msg.value;
	}
	
	// Step 10: Creating a function to send an invoice
	function sendInvoice(uint orderNo, uint order_date) payable public {
		// Now only the owner can use this function
		require(ownerAddress == msg.sender);
		// We need to check if the order exists
		require(orders[orderNo].created);
		// Increasing the invoice index
		invoiceseq++;
		// Creating the invoice
		invoices[invoiceseq] = Invoice(invoiceseq, orderNo, true);
		// Setting the order date
		orders[orderNo].dateOfOrder = order_date;
	}
	
    // Step 11: Creating a function to send price
	function sendPrice(uint orderNo, uint price) payable public {		
		// Now only the owner can use this function
		require(msg.sender == ownerAddress);
		// We need to check if the order exists
		require(orders[orderNo].created);
		// Setting the order price
		orders[orderNo].price = price;
	}

	// Step 12: Creating a function to receive an invoice
	function getInvoice(uint invoiceID) view public returns (address customer, uint orderNo, uint invoice_date){
		// We need to check if the invoice exists
		require(invoices[invoiceID].created);
		// Retrieving the related invoice info
		Invoice storage _invoice = invoices[invoiceID];
		// Retrieving the related order info
		Order storage _order     = orders[_invoice.orderNo];		
		// Returning the invoice
		return (customerAddress, _order.ID, _order.dateOfOrder);
	}
	
}