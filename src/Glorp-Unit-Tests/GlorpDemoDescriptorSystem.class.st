Class {
	#name : #GlorpDemoDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#classVars : [
		'Default'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'accessing - defaults' }
GlorpDemoDescriptorSystem class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : #other }
GlorpDemoDescriptorSystem >> allTableNames [
	^#('GR_ADDRESS' 'PERSON' 'GR_CUSTOMER' 'BANK_TRANS' 'BANK_ACCT' 'CUSTOMER_ACCT_LINK' 'EMAIL_ADDRESS' 'STUFF' 'PASSENGER' 'AIRLINE' 'FREQUENT_FLYER' 'COMPRESSED_MONEY_TABLE' 'RESERVATION' 'ITINERARY' 'TRANSFORMED_TIME' 'FKCONTACT' 'FKADDRESS' 'GLORP_OWNER' 'GLORP_SLAVE' 'TREE_NODE' 'TREE_NODE_LINK' 'RECORD_WITH_UPDATE' 'GR_TRAVEL_AGENT').
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> classModelForDefaultableThing: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #boolean type: Boolean.
	aClassModel newAttributeNamed: #integer type: Integer.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpAirline: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpBankAccount: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #accountNumber type: GlorpBankAccountNumber.
	aClassModel newAttributeNamed: #accountHolders collectionOf: GlorpCustomer.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpBankAccountNumber: aClassModel [

	aClassModel newAttributeNamed: #bankCode.
	aClassModel newAttributeNamed: #branchNumber.
	aClassModel newAttributeNamed: #accountNumber.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpBankBranch: aClassModel [
	aClassModel newAttributeNamed: #branchNumber.
	aClassModel newAttributeNamed: #accounts collectionOf: GlorpBankAccount.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpBankTransaction: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #owner type: GlorpCustomer.
	aClassModel newAttributeNamed: #amount type: GlorpMoney.
	aClassModel newAttributeNamed: #serviceCharge type: GlorpServiceCharge.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpCustomer: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #transactions collectionOf: GlorpBankTransaction.
	aClassModel newAttributeNamed: #accounts collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedById collectionOf: GlorpBankAccount.
	aClassModel newAttributeNamed: #accountsSortedByIdDescending collectionOf: GlorpBankAccount.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpEmailAddress: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #user.
	aClassModel newAttributeNamed: #host.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpItinerary: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #reservation type: GlorpReservation.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpMoney: aClassModel [

	aClassModel newAttributeNamed: #currency.
	aClassModel newAttributeNamed: #amount.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpPassenger: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #frequentFlyerMiles.
	aClassModel newAttributeNamed: #airline type: GlorpAirline.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpPerson: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #address type: GlorpAddress.
	aClassModel newAttributeNamed: #emailAddresses collectionOf: GlorpEmailAddress.
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> classModelForGlorpRecordWithUpdateTime: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #updateTime type: Dialect timestampClass.
	aClassModel newAttributeNamed: #updateSomeOtherThing type: String.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpReservation: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #passengers collectionOf: GlorpPassenger.
	aClassModel newAttributeNamed: #passenger type: GlorpPassenger.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> classModelForGlorpServiceCharge: aClassModel [

	aClassModel newAttributeNamed: #description.
	aClassModel newAttributeNamed: #amount type: GlorpMoney.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpTravelAgency: aClassModel [
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #agents collectionOf: GlorpTravelAgent.
]

{ #category : #'class models/airline' }
GlorpDemoDescriptorSystem >> classModelForGlorpTravelAgent: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #agency type: GlorpTravelAgency.
]

{ #category : #'descriptors/tree nodes' }
GlorpDemoDescriptorSystem >> classModelForGlorpTreeNode: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #children collectionOf: GlorpTreeNode.
]

{ #category : #other }
GlorpDemoDescriptorSystem >> constructAllClasses [
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
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> descriptorForDefaultableThing: aDescriptor [
	| table |
	table := self tableNamed: 'DEFAULTABLE_THING'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #boolean
		to: (table fieldNamed: 'MY_BOOL').
	(aDescriptor newMapping: DirectMapping)
		from: #integer
		to: (table fieldNamed: 'MY_INT').
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpAirline: aDescriptor [ 
	aDescriptor table: (self tableNamed: 'AIRLINE').
	aDescriptor directMappingFor: #id.
	aDescriptor directMappingFor: #name.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpBankAccount: aDescriptor [ 

	| table |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
				to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: ToManyMapping)
				attributeName: #accountHolders;
				useLinkTable.
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #accountNumber.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpBankAccountNumber: aDescriptor [

	| table |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
"	aDescriptor addMapping: ((DirectMapping from: #bankCode to: (table fieldNamed: 'BANK_CODE')) type: Integer)."
	(aDescriptor newMapping: DirectMapping) from: #bankCode to: (table fieldNamed: 'BANK_CODE').
	(aDescriptor newMapping: DirectMapping) from: #branchNumber to: (table fieldNamed: 'BRANCH_NO').
	(aDescriptor newMapping: DirectMapping) from: #accountNumber to: (table fieldNamed: 'ACCT_NO').
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpBankBranch: aDescriptor [

	| table distinctBranchNumber mapping |
	table := self tableNamed: 'BANK_ACCT'.
	aDescriptor table: table.
	distinctBranchNumber := [:each | ((each getTable: table) getField: (table fieldNamed: 'BRANCH_NO')) distinct] asGlorpExpression.
	mapping := aDescriptor newMapping: DirectMapping.
	mapping from: #branchNumber to: distinctBranchNumber.
	mapping readOnly: true.

	aDescriptor keyFields: (Array with: distinctBranchNumber).

	(aDescriptor newMapping: ToManyMapping)
		attributeName: #accounts;
		readOnly: true;
		join: 
						(Join
								from: distinctBranchNumber
								to: (table fieldNamed: 'BRANCH_NO')).
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpBankTransaction: aDescriptor [
	| table | 
	table := self tableNamed: 'BANK_TRANS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id
				to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: OneToOneMapping)
				attributeName: #owner.
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #amount;
				fieldTranslation: ((Join new)
							addSource: (table fieldNamed: 'AMT_AMT')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'AMOUNT');
							addSource: (table fieldNamed: 'AMT_CURR')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'CURRENCY');
							yourself).
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #serviceCharge.
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> descriptorForGlorpCompressedMoney: aDescriptor [ 
	| table currencyField amountField |
	table := self tableNamed: 'COMPRESSED_MONEY_TABLE'.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	currencyField := table fieldNamed: 'CURRENCY_NAME'.
	amountField := table fieldNamed: 'AMOUNT'.
	aDescriptor table: table.
	aDescriptor addMapping: (AdHocMapping 
				forAttribute: #array
				fromDb: 
					[:row :elementBuilder :context| 
					Array with: (elementBuilder valueOfField: (context translateField: currencyField) in: row)
						with: (elementBuilder valueOfField: (context translateField: amountField) in: row)]
				toDb: 
					[:rows :attribute :attributeRows | 
					(rows at: table) at: currencyField put: (attribute at: 1).
					(rows at: table) at: amountField put: (attribute at: 2)]
				mappingFields: (Array with: currencyField with: amountField)).
	"Note that position won't work if we have a join. We need to take the elementbuilder into account"
	^aDescriptor
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpCustomer: aDescriptor [

	| table |
	table := self tableNamed: 'GR_CUSTOMER'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME'); shouldProxy: true.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #transactions.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #accounts;
			useLinkTable.

	"Two additional relationships, there to test ordering within a mapping, where the order is determined by a field in the link table"
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #accountsSortedById;
			readOnly: true;
			useLinkTable;
			orderBy: [:each | (each getTable: 'CUSTOMER_ACCT_LINK') getField: 'ACCT_ID'].
	(aDescriptor newMapping: ManyToManyMapping)
			attributeName: #accountsSortedByIdDescending;
			readOnly: true;
			useLinkTable;
			orderBy: [:each | ((each getTable: 'CUSTOMER_ACCT_LINK') getField: 'ACCT_ID') descending].
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpEmailAddress: aDescriptor [

	| table |
	table := self tableNamed: 'EMAIL_ADDRESS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #user to: (table fieldNamed: 'USER_NAME').
	(aDescriptor newMapping: DirectMapping) from: #host to: (table fieldNamed: 'HOST_NAME').
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpItinerary: aDescriptor [ 
	aDescriptor table: (self tableNamed: 'ITINERARY').
	aDescriptor directMappingFor: #id.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #reservation.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpMoney: aDescriptor [

	| table |
	table := self tableNamed: 'MONEY_IMAGINARY_TABLE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #currency type: Symbol to: (table fieldNamed: 'CURRENCY').
	(aDescriptor newMapping: DirectMapping) from: #amount to: (table fieldNamed: 'AMOUNT').
	^aDescriptor.
]

{ #category : #owner }
GlorpDemoDescriptorSystem >> descriptorForGlorpOwner: aDescriptor [
	| table slaveTable |
	table := self tableNamed: 'GLORP_OWNER'.
	slaveTable := self tableNamed: 'GLORP_SLAVE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID'));
		addMapping:
				((OneToManyMapping new)
						attributeName: #slaves;
						referenceClass: GlorpSlave;
						collectionType: OrderedCollection;
						orderBy:
								[:each | (each getTable: 'GLORP_SLAVE') getField: 'POSITION_IN_OWNER'];
						writeTheOrderField;
						mappingCriteria:
								(Join
										from: (table fieldNamed: 'ID')
										to: (slaveTable fieldNamed: 'OWNER_ID')));
		addMapping:
				((OneToOneMapping new)
						attributeName: #slave;
						referenceClass: GlorpSlave;
						mappingCriteria:
								(Join
										from: (table fieldNamed: 'SLAVE_ID')
										to: (slaveTable fieldNamed: 'ID'))).
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpPassenger: aDescriptor [ 
	| passTable ffTable ffMiles airlineMapping |
	passTable := self tableNamed: 'PASSENGER'.
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	aDescriptor table: passTable.
	aDescriptor addTable: ffTable.
	aDescriptor addMultipleTableJoin: (	
		Join 
			from: (passTable fieldNamed: 'ID')
			to: (ffTable fieldNamed: 'ID')) beOuterJoin.
	(aDescriptor newMapping: DirectMapping) from: #id to: (passTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (passTable fieldNamed: 'NAME').

	ffMiles := aDescriptor newMapping: ConditionalMapping.
	ffMiles 
		forField: (ffTable fieldNamed: 'POINTS')
		attribute: [:object | object frequentFlyerPoints]
		if: [:x | x notNil]
		useMapping: ((ffMiles newMapping: DirectMapping) from: #frequentFlyerMiles to: (ffTable fieldNamed: 'POINTS')).
	ffMiles otherwise: (ffMiles newMapping: ConstantMapping).
	
	airlineMapping := aDescriptor newMapping: ConditionalMapping.
	airlineMapping
		forField: (ffTable fieldNamed: 'AIRLINE_ID')
		attribute: [:object | object airline]
		if: [:x | x notNil]
		useMapping: ((airlineMapping newMapping: OneToOneMapping) attributeName: #airline).
	airlineMapping otherwise: (airlineMapping newMapping: ConstantMapping).
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpPerson: aDescriptor [

	| table |
	table := self tableNamed: 'PERSON'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) fromPseudoVariable: #addressId to: (table fieldNamed: 'ADDRESS_ID').
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #address.
	(aDescriptor newMapping: ToManyMapping)
			attributeName: #emailAddresses;
			orderBy: #id.
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> descriptorForGlorpRecordWithUpdateTime: aDescriptor [
	| table |
	table := self tableNamed: 'RECORD_WITH_UPDATE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping)
		from: #updateTime
		to: (table fieldNamed: 'UPDATE_TIME').
	(aDescriptor newMapping: DirectMapping)
		from: #updateSomeOtherThing
		to: (table fieldNamed: 'UPDATE_OTHER_THING').
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpReservation: aDescriptor [ 
	| table |
	table := self tableNamed: 'RESERVATION'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	"The res->passenger relationship is actually 1-1, but map it as both 1-1 and 1-many so that we can more easily verify that only one object comes back, i.e. that joins are being done correctly"
	(aDescriptor newMapping: OneToManyMapping)
			attributeName: #passengers.
	(aDescriptor newMapping: OneToOneMapping)
			attributeName: #passenger.
]

{ #category : #'descriptors/bank' }
GlorpDemoDescriptorSystem >> descriptorForGlorpServiceCharge: aDescriptor [ 
	
	| table |
	table := self tableNamed: 'BANK_TRANS'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #description
				to: (table fieldNamed: 'SRVC_DESC').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
				attributeName: #amount;
				fieldTranslation: ((Join new)
							addSource: (table fieldNamed: 'SRVC_AMT_AMT')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'AMOUNT');
							addSource: (table fieldNamed: 'SRVC_AMT_CURR')
								target: ((self tableNamed: 'MONEY_IMAGINARY_TABLE') fieldNamed: 'CURRENCY');
							yourself).
]

{ #category : #owner }
GlorpDemoDescriptorSystem >> descriptorForGlorpSlave: aDescriptor [
	| table |
	table := self tableNamed: 'GLORP_SLAVE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> descriptorForGlorpTransformedTime: aDescriptor [ 
	| table timeField |
	table := self tableNamed: 'TRANSFORMED_TIME'.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	timeField := table fieldNamed: 'TIMEFIELD'.
	aDescriptor table: table.
	aDescriptor addMapping: (AdHocMapping 
				forAttribute: #time
				fromDb: 
					[:row :elementBuilder :context| 
					Time fromSeconds: (elementBuilder valueOfField: (context translateField: timeField) in: row) ]
				toDb: 
					[:rows :attribute :attributeRows | 
					(rows at: table) at: timeField put: attribute asSeconds]
				mappingFields: (Array with: timeField)).
	"Note that position won't work if we have a join. We need to take the elementbuilder into account"
	^aDescriptor
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpTravelAgency: aDescriptor [
	| table |
	table := self tableNamed: 'GR_TRAVEL_AGENT'.
	aDescriptor table: table.
	aDescriptor directMapping from: #name to: (table fieldNamed: 'AGENCY_NAME').
	aDescriptor toManyMapping
			attributeName: #agents;
			join: (Join from: (table fieldNamed: 'AGENCY_NAME') to: (table fieldNamed: 'AGENCY_NAME')).
]

{ #category : #'descriptors/airline' }
GlorpDemoDescriptorSystem >> descriptorForGlorpTravelAgent: aDescriptor [
	| table |
	table := self tableNamed: 'GR_TRAVEL_AGENT'.
	aDescriptor table: table.
	aDescriptor directMapping from: #id to: (table fieldNamed: 'ID').
	aDescriptor directMapping from: #name to: (table fieldNamed: 'AGENT_NAME').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
			attributeName: #agency.
]

{ #category : #'descriptors/tree nodes' }
GlorpDemoDescriptorSystem >> descriptorForGlorpTreeNode: aDescriptor [
	| table |
	table := self tableNamed: 'TREE_NODE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: ToManyMapping)
		attributeName: #children;
		useLinkTable;
		join:
				(Join
						from: (table fieldNamed: 'ID')
						to: ((self tableNamed: 'TREE_NODE_LINK') fieldNamed: 'PARENT')).
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAccountRow1 [

	| accountTable row |
	accountTable := self tableNamed: 'BANK_ACCT'.
	row := DatabaseRow newForTable: accountTable.
	row at: (accountTable fieldNamed: 'ID') put: 9874.
	row at: (accountTable fieldNamed: 'BANK_CODE') put: '1'.
	row at: (accountTable fieldNamed: 'BRANCH_NO') put: 2.
	row at: (accountTable fieldNamed: 'ACCT_NO') put: '3'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAccountRow2 [

	| accountTable row |
	accountTable := self tableNamed: 'BANK_ACCT'.
	row := DatabaseRow newForTable: accountTable.
	row at: (accountTable fieldNamed: 'ID') put: 6.
	row at: (accountTable fieldNamed: 'BANK_CODE') put: '2'.
	row at: (accountTable fieldNamed: 'BRANCH_NO') put: 3.
	row at: (accountTable fieldNamed: 'ACCT_NO') put: '4'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAccountRow3 [

	| accountTable row |
	accountTable := self tableNamed: 'BANK_ACCT'.
	row := DatabaseRow newForTable: accountTable.
	row at: (accountTable fieldNamed: 'ID') put: 22.
	row at: (accountTable fieldNamed: 'BANK_CODE') put: '2'.
	row at: (accountTable fieldNamed: 'BRANCH_NO') put: 712.
	row at: (accountTable fieldNamed: 'ACCT_NO') put: '5551212'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRow [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 123.
	row at: (addressTable fieldNamed: 'STREET') put: 'Paseo Montril'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '10185'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowForOrdering1 [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 1.
	row at: (addressTable fieldNamed: 'STREET') put: 'Alpha'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '300'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowForOrdering2 [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 2.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '200'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowForOrdering3 [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 3.
	row at: (addressTable fieldNamed: 'STREET') put: 'Gamma'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '100'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowForOrdering4 [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 6.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '120'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowForOrdering5 [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 4.
	row at: (addressTable fieldNamed: 'STREET') put: 'Beta'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '130'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleAddressRowWithDifferentStreet [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 123.
	row at: (addressTable fieldNamed: 'STREET') put: 'Garden of the Gods'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '10185'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleBankTransactionRow [
	| table row |
	table := self tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.

	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'OWNER_ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'CDN'.
	row atFieldNamed: 'AMT_AMT' put: 7.
	row atFieldNamed: 'SRVC_DESC' put: 'additional overcharge'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'USD'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 2.

	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleBankTransactionRow2 [
	| table row |
	table := self tableNamed: 'BANK_TRANS'.
	row := DatabaseRow newForTable: table.

	row atFieldNamed: 'ID' put: nil.
	row atFieldNamed: 'OWNER_ID' put: nil.
	row atFieldNamed: 'AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'AMT_AMT' put: 45.
	row atFieldNamed: 'SRVC_DESC' put: 'deposit'.
	row atFieldNamed: 'SRVC_AMT_CURR' put: 'EUR'.
	row atFieldNamed: 'SRVC_AMT_AMT' put: 1.

	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCALinkRow1 [

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 9874.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 27.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCALinkRow2 [

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 6.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 27.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCALinkRow3 [

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 22.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 28.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCALinkRow4 [

	| linkTable row |
	linkTable := self tableNamed: 'CUSTOMER_ACCT_LINK'.
	row := DatabaseRow newForTable: linkTable.
	row at: (linkTable fieldNamed: 'ACCT_ID') put: 6.
	row at: (linkTable fieldNamed: 'CUSTOMER_ID') put: 28.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCompressedMoneyRow [
	| table row |
	table := self  tableNamed: 'COMPRESSED_MONEY_TABLE'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 123.
	row at: (table fieldNamed: 'AMOUNT') put: 12.
	row at: (table fieldNamed: 'CURRENCY_NAME') put: 'CDN'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCompressedMoneyRow2 [
	| table row |
	table := self  tableNamed: 'COMPRESSED_MONEY_TABLE'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 124.
	row at: (table fieldNamed: 'AMOUNT') put: 15.
	row at: (table fieldNamed: 'CURRENCY_NAME') put: 'CDN'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCustomerRow1 [

	| customerTable row |
	customerTable := self tableNamed: 'GR_CUSTOMER'.
	row := DatabaseRow newForTable: customerTable.
	row at: (customerTable fieldNamed: 'ID') put: 27.
	row at: (customerTable fieldNamed: 'NAME') put: 'aCustomer'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleCustomerRow2 [

	| customerTable row |
	customerTable := self tableNamed: 'GR_CUSTOMER'.
	row := DatabaseRow newForTable: customerTable.
	row at: (customerTable fieldNamed: 'ID') put: 28.
	row at: (customerTable fieldNamed: 'NAME') put: 'anotherCustomer'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleEmailAddressRow1 [

	| personTable row |
	personTable := self tableNamed: 'EMAIL_ADDRESS'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 42.
	row at: (personTable fieldNamed: 'USER_NAME') put: 'alan'.
	row at: (personTable fieldNamed: 'HOST_NAME') put: 'objectpeople.com'.
	row at: (personTable fieldNamed: 'PERSON_ID') put: 3.

	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleEmailAddressRow2 [

	| personTable row |
	personTable := self tableNamed: 'EMAIL_ADDRESS'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 54321.
	row at: (personTable fieldNamed: 'USER_NAME') put: 'johnson'.
	row at: (personTable fieldNamed: 'HOST_NAME') put: 'cs.uiuc.edu'.
	row at: (personTable fieldNamed: 'PERSON_ID') put: 3.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleFrequentFlyerRow [
	| ffTable row |
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	row := DatabaseRow newForTable: ffTable.
	row at: (ffTable fieldNamed: 'ID') put: 1.
	row at: (ffTable fieldNamed: 'POINTS') put: 10000.
	row at: (ffTable fieldNamed: 'AIRLINE_ID') put: nil.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleFrequentFlyerRow2 [
	| ffTable row |
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	row := DatabaseRow newForTable: ffTable.
	row at: (ffTable fieldNamed: 'ID') put: 2.
	row at: (ffTable fieldNamed: 'POINTS') put: 7.
	row at: (ffTable fieldNamed: 'AIRLINE_ID') put: nil.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> exampleModifiedAddressRow [
	| addressTable row |
	addressTable := self  tableNamed: 'GR_ADDRESS'.
	row := DatabaseRow newForTable: addressTable.
	row at: (addressTable fieldNamed: 'ID') put: 123.
	row at: (addressTable fieldNamed: 'STREET') put: 'Something Else'.
	row at: (addressTable fieldNamed: 'HOUSE_NUM') put: '10185'.
	^row
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePassengerRow [
	| passengerTable row |
	passengerTable := self tableNamed: 'PASSENGER'.
	row := DatabaseRow newForTable: passengerTable.
	row at: (passengerTable fieldNamed: 'ID') put: 1.
	row at: (passengerTable fieldNamed: 'NAME') put: 'Some Passenger'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePassengerRow2 [
	| passengerTable row |
	passengerTable := self tableNamed: 'PASSENGER'.
	row := DatabaseRow newForTable: passengerTable.
	row at: (passengerTable fieldNamed: 'ID') put: 2.
	row at: (passengerTable fieldNamed: 'NAME') put: 'Another Passenger'.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePersonRow1 [

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 3.
	row at: (personTable fieldNamed: 'NAME') put: 'aPerson'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 123.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePersonRow2 [

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 4.
	row at: (personTable fieldNamed: 'NAME') put: 'aPerson'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: nil.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePersonRowForOrdering1 [

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 86.
	row at: (personTable fieldNamed: 'NAME') put: 'person1'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 2.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePersonRowForOrdering2 [

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 87.
	row at: (personTable fieldNamed: 'NAME') put: 'person2'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 3.
	^row.
]

{ #category : #examples }
GlorpDemoDescriptorSystem >> examplePersonRowForOrdering3 [

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 88.
	row at: (personTable fieldNamed: 'NAME') put: 'person3'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 1.
	^row.
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForAIRLINE: aTable [

	(aTable createFieldNamed: 'ID' type: platform inMemorySequence) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20)
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForAIRLINE_MEAL: aTable [

	aTable createFieldNamed: 'ID' type: platform int4.
	aTable createFieldNamed: 'DESCR' type: (platform varChar: 20).
	aTable createFieldNamed: 'FLIGHT_ID' type: platform int4
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForBANK_ACCT: aTable [

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'BANK_CODE' type: (platform varChar: 10).
	aTable createFieldNamed: 'BRANCH_NO' type: (platform int4).
	aTable createFieldNamed: 'ACCT_NO' type: (platform varChar: 10).
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForBANK_TRANS: aTable [ 
	| ownerId |
	(aTable createFieldNamed: 'ID' type: (platform serial: 3))
		bePrimaryKey.
	ownerId := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	aTable addForeignKeyFrom: ownerId
		to: ((self tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	aTable createFieldNamed: 'AMT_CURR' type: (platform varChar: 5).
	aTable createFieldNamed: 'AMT_AMT' type: platform int4.
	aTable createFieldNamed: 'SRVC_DESC' type: (platform varChar: 30).
	aTable createFieldNamed: 'SRVC_AMT_CURR' type: (platform varChar: 5).
	aTable createFieldNamed: 'SRVC_AMT_AMT' type: platform int4.
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForCOMPRESSED_MONEY_TABLE: aTable [
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'CURRENCY_NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AMOUNT' type: platform int4.
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForCUSTOMER_ACCT_LINK: aTable [

	| customerId accountId |
	customerId := (aTable createFieldNamed: 'CUSTOMER_ID' type: platform int4).
	aTable addForeignKeyFrom: customerId to: ((self tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	accountId := aTable createFieldNamed: 'ACCT_ID' type: platform int4.
	aTable addForeignKeyFrom: accountId to: ((self tableNamed: 'BANK_ACCT') fieldNamed: 'ID').
	aTable addIndexForFields: (Array with: customerId with: accountId).
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> tableForDEFAULTABLE_THING: aTable [ 
	| boolean converter |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	boolean := aTable createFieldNamed: 'MY_BOOL' type: (platform boolean).
	"We want a default value for this field, but we can't just use a boolean, because in some database we can represent that directly, but in others it will need to be converted to an integer. And likewise we can't just use an integer, so we need to do an explicit conversion."
	converter := boolean converterForStType: Boolean.
	boolean defaultValue: (converter convert: false toDatabaseRepresentationAs: boolean type).
	(aTable createFieldNamed: 'MY_INT' type: (platform int4)) defaultValue: 4.
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForEMAIL_ADDRESS: aTable [

	| personId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	(aTable createFieldNamed: 'USER_NAME' type: (platform varChar: 20)) beIndexed.
	aTable createFieldNamed: 'HOST_NAME' type: (platform varChar: 20).
	personId := aTable createFieldNamed: 'PERSON_ID' type: platform int4.
	personId beIndexed.
	(aTable addForeignKeyFrom: personId to: ((self tableNamed: 'PERSON') fieldNamed: 'ID')).
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForFKADDRESS: aTable [ 
	| contact |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	contact := aTable createFieldNamed: 'CONTACT_ID' type: platform int4.
	aTable addForeignKeyFrom: contact
		to: ((self tableNamed: 'FKCONTACT') fieldNamed: 'ID')
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForFKCONTACT: aTable [ 
	| address |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	address := aTable createFieldNamed: 'ADDRESS_ID' type: platform int4.
	aTable addForeignKeyFrom: address
		to: ((self tableNamed: 'FKADDRESS') fieldNamed: 'ID')
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForFLIGHT: aTable [

	aTable name: 'FLIGHT'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'FLIGHT_NUM' type: platform int4
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForFLIGHT_PASS: aTable [

	| flight pass airline |
	aTable name: 'FLIGHT_PASS'.
	flight := aTable createFieldNamed: 'FLIGHT_ID' type: platform int4.
	aTable addForeignKeyFrom: flight
		to: ((self tableNamed: 'FLIGHT') fieldNamed: 'ID').
	pass := aTable createFieldNamed: 'PASS_ID' type: platform int4.
	aTable addForeignKeyFrom: pass
		to: ((self tableNamed: 'PASSENGER') fieldNamed: 'ID').
	airline := aTable createFieldNamed: 'AIRLINE_ID' type: platform int4.
	aTable addForeignKeyFrom: airline
		to: ((self tableNamed: 'AIRLINE') fieldNamed: 'ID').
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForFREQUENT_FLYER: aTable [ 
	| airlineId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'POINTS' type: platform int4.
	airlineId := aTable createFieldNamed: 'AIRLINE_ID' type: platform int4.
	aTable addForeignKeyFrom: airlineId to: ((self tableNamed: 'AIRLINE') fieldNamed: 'ID').
]

{ #category : #owner }
GlorpDemoDescriptorSystem >> tableForGLORP_OWNER: aTable [
	| field |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	field := aTable createFieldNamed: 'SLAVE_ID' type: platform int4.
	aTable
		addForeignKeyFrom: field
		to: ((self tableNamed: 'GLORP_SLAVE') fieldNamed: 'ID').
]

{ #category : #owner }
GlorpDemoDescriptorSystem >> tableForGLORP_SLAVE: aTable [
	| field constraint |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'POSITION_IN_OWNER' type: platform int4.
	field := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	"Don't actually create this constraint because it causes a cycle that can confuse our sorting mechanism."
	"constraint := aTable
		addForeignKeyFrom: field
		to: ((self tableNamed: 'GLORP_OWNER') fieldNamed: 'ID').
	constraint shouldCreateInDatabase: false."
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForGR_ADDRESS: aTable [ 

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'STREET' type: (platform varChar: 20).
	aTable createFieldNamed: 'HOUSE_NUM' type: (platform varChar: 20)
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForGR_CUSTOMER: aTable [ 
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20)
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForGR_TRAVEL_AGENT: aTable [ 

	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'AGENT_NAME' type: (platform varchar: 50).
	aTable createFieldNamed: 'AGENCY_NAME' type: (platform varchar: 50).
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForITINERARY: aTable [ 

	| res |
	(aTable createFieldNamed: 'ID' type: platform serial)
		bePrimaryKey.
	res := aTable createFieldNamed: 'RES_ID' type: (platform int4).
	aTable addForeignKeyFrom: res
		to: ((self tableNamed: 'RESERVATION') fieldNamed: 'ID').
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForMONEY_IMAGINARY_TABLE: aTable [

	aTable isImaginary: true.
	aTable createFieldNamed: 'CURRENCY' type: (platform varChar: 5).
	aTable createFieldNamed: 'AMOUNT' type: platform int4
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForPASSENGER: aTable [
	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20)
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForPERSON: aTable [
	| addrId|
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	addrId := aTable createFieldNamed: 'ADDRESS_ID' type: platform int4.
	aTable addForeignKeyFrom: addrId to: ((self tableNamed: 'GR_ADDRESS') fieldNamed: 'ID').
]

{ #category : #'descriptors/other' }
GlorpDemoDescriptorSystem >> tableForRECORD_WITH_UPDATE: aTable [ 
	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	(aTable createFieldNamed: 'NAME' type: (platform varchar: 20)).
	aTable createFieldNamed: 'UPDATE_TIME' type: (platform versionFieldFor: platform timestamp) generateOverExistingValues.
	"OK, it's not much of a comment, we just print the current time. Note that this field is completely unmapped"
	aTable createFieldNamed: 'UPDATE_COMMENT' type: (platform generatorFor: (platform varchar: 20) withBlock: [Time now printString]) generateOverExistingValues.
	"But this one *is* mapped"
	aTable createFieldNamed: 'UPDATE_OTHER_THING' type: (platform generatorFor: (platform varchar: 20) withBlock: [Time now printString]) generateOverExistingValues.
]

{ #category : #'tables/airline' }
GlorpDemoDescriptorSystem >> tableForRESERVATION: aTable [ 

	| pass |
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	pass := aTable createFieldNamed: 'PASS_ID' type: (platform int4).
	aTable addForeignKeyFrom: pass
		to: ((self tableNamed: 'PASSENGER') fieldNamed: 'ID').
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForSTUFF: aTable [ 

	(aTable createFieldNamed: 'ID' type: platform inMemorySequence)
		bePrimaryKey.
	aTable createFieldNamed: 'THING' type: (platform varChar: 20)
]

{ #category : #tables }
GlorpDemoDescriptorSystem >> tableForTRANSFORMED_TIME: aTable [
	(aTable createFieldNamed: 'ID' type: platform int4)
		bePrimaryKey.
	aTable createFieldNamed: 'TIMEFIELD' type: platform int4.
]

{ #category : #'descriptors/tree nodes' }
GlorpDemoDescriptorSystem >> tableForTREE_NODE: aTable [

	| |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
]

{ #category : #'descriptors/tree nodes' }
GlorpDemoDescriptorSystem >> tableForTREE_NODE_LINK: aTable [

	| parent child |
	parent := (aTable createFieldNamed: 'PARENT' type: platform int4) bePrimaryKey.
	(aTable addForeignKeyFrom: parent
		to: ((self tableNamed: 'TREE_NODE') fieldNamed: 'ID')) "shouldCreateInDatabase: false"  .
	child := (aTable createFieldNamed: 'CHILD' type: platform int4) bePrimaryKey.
	(aTable addForeignKeyFrom: child
		to: ((self tableNamed: 'TREE_NODE') fieldNamed: 'ID')) "shouldCreateInDatabase: false".
]

{ #category : #'test support' }
GlorpDemoDescriptorSystem >> testIDLessThan5: aValue [
	"A test method, used for conditional mapping tests"
	^aValue < 5.
]

{ #category : #'test support' }
GlorpDemoDescriptorSystem >> testIDMoreThan5: aValue [
	"A test method, used for conditional mapping tests"
	^aValue > 5.
]

{ #category : #support }
GlorpDemoDescriptorSystem >> writeCustomer1Rows [
	| linkRow2 id2 id1 accountRow1 customerRow accountRow2 linkRow1 |
	customerRow := self exampleCustomerRow1.
	accountRow1 := self exampleAccountRow1.
	accountRow2 := self exampleAccountRow2.
	linkRow1 := self exampleCALinkRow1.
	linkRow2 := self exampleCALinkRow2.
	session writeRow: customerRow.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	id1 := accountRow1 at: (accountRow1 table fieldNamed: 'ID').
	id2 := accountRow2 at: (accountRow2 table fieldNamed: 'ID').
	^Array with: id1 with: id2.
]

{ #category : #support }
GlorpDemoDescriptorSystem >> writeCustomerWithDualAccountOwners [
	| linkRow2 id2 id1 accountRow1 accountRow2 linkRow1 customer1Row customer2Row linkRow4 |
	customer1Row := self exampleCustomerRow1.
	customer2Row := self exampleCustomerRow2.
	accountRow1 := self exampleAccountRow1.
	accountRow2 := self exampleAccountRow2.
	linkRow1 := self exampleCALinkRow1.
	linkRow2 := self exampleCALinkRow2.
	linkRow4 := self exampleCALinkRow4.
	session writeRow: customer1Row.
	session writeRow: customer2Row.
	session writeRow: accountRow1.
	session writeRow: accountRow2.
	session writeRow: linkRow1.
	session writeRow: linkRow2.
	session writeRow: linkRow4.
	id1 := accountRow1 at: (accountRow1 table fieldNamed: 'ID').
	id2 := accountRow2 at: (accountRow2 table fieldNamed: 'ID').
	^Array with: id1 with: id2.
]
