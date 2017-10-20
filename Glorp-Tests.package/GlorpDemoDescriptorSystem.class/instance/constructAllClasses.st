other
constructAllClasses
	"This includes a list of classes as an example, but we don't actually use most of them, because the superclass method will figure it out if the descriptor methods are written in this class."
	^(super constructAllClasses) 
		add: GlorpAddress;
		yourself.
"	^(super constructAllClasses)
		add: GlorpPerson;
		add: GlorpAddress;
		add: GlorpCustomer;
		add: GlorpBankTransaction;
		add: GlorpBankAccount;
		add: GlorpMoney;
		add: GlorpCompressedMoney;
		add: GlorpServiceCharge;
		add: GlorpBankAccountNumber;
		add: GlorpEmailAddress;
		add: GlorpPassenger;
		add: GlorpAirline;
		add: GlorpReservation;
		add: GlorpItinerary;
		add: GlorpTransformedTime;
		add: GlorpBankBranch;
		add: GlorpOwner;
		add: GlorpSlave;
		add: GlorpTreeNode;
		add: GlorpRecordWithUpdateTime;
		add: GlorpTravelAgent;
		add: GlorpTravelAgency;
		yourself."