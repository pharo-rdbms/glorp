Class {
	#name : #GlorpMappingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'rowMap'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpMappingTest >> helperForMergedOneToOneReversingWriteOrder: aBoolean [ 
	| account accountTable row |
	account := GlorpBankExampleSystem new objectNumber: 1 ofClass: GlorpBankAccount.
	accountTable := system tableNamed: 'BANK_ACCT'.
	aBoolean 
		ifTrue: 
			[self write: account.
			self write: account accountNumber]
		ifFalse: 
			[self write: account accountNumber.
			self write: account].
	self assert: (rowMap includesRowForTable: accountTable withKey: account).
	self assert: (rowMap includesRowForTable: accountTable
				withKey: account accountNumber).
	row := self rowFor: account.
	self assert: (row at: (accountTable fieldNamed: 'ID')) = account id.
	(Array with: row with: (self rowFor: account accountNumber)) do: 
			[:each | 
			self assert: (each at: (accountTable fieldNamed: 'BANK_CODE')) 
						= account accountNumber bankCode.
			self assert: (each at: (accountTable fieldNamed: 'BRANCH_NO')) 
						= account accountNumber branchNumber.
			self assert: (each at: (accountTable fieldNamed: 'ACCT_NO')) 
						= account accountNumber accountNumber].
	self assert: (rowMap numberOfEntriesForTable: accountTable) = 2
]

{ #category : #tests }
GlorpMappingTest >> helperForNestedMergedOneToOneReversingWriteOrder: aBoolean [ 
	| trans transTable moneyTable row fieldNames fieldValues |
	trans := GlorpBankExampleSystem new objectNumber: 1
				ofClass: GlorpBankTransaction.
	transTable := system tableNamed: 'BANK_TRANS'.
	moneyTable := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	aBoolean 
		ifTrue: 
			[self write: trans.
			self write: trans amount.
			self write: trans serviceCharge.
			self write: trans serviceCharge amount]
		ifFalse: 
			[self write: trans serviceCharge amount.
			self write: trans serviceCharge.
			self write: trans amount.
			self write: trans].
	self 
		assert: (rowMap rowForTable: transTable withKey: trans) shouldBeWritten.
	self 
		assert: (rowMap rowForTable: transTable withKey: trans serviceCharge) 
				shouldBeWritten not.
	self 
		assert: (rowMap rowForTable: moneyTable withKey: trans amount) 
				shouldBeWritten not.
	self 
		assert: (rowMap rowForTable: moneyTable withKey: trans serviceCharge amount) 
				shouldBeWritten not.
	row := self rowFor: trans.
	self assert: (row at: (transTable fieldNamed: 'ID')) = trans id.
	fieldNames := #('AMT_CURR' 'AMT_AMT' 'SRVC_DESC' 'SRVC_AMT_CURR' 'SRVC_AMT_AMT').
	fieldValues := (Array 
				with: trans amount currency asString
				with: trans amount amount
				with: trans serviceCharge description) 
					, (Array with: trans serviceCharge amount currency asString
							with: trans serviceCharge amount amount).
	fieldNames with: fieldValues
		do: [:fieldName :value | self assert: (row at: (transTable fieldNamed: fieldName)) = value].
	self assert: (rowMap numberOfEntriesForTable: transTable) = 2.
	self assert: (rowMap numberOfEntriesForTable: moneyTable) = 2
]

{ #category : #support }
GlorpMappingTest >> rowFor: anObject [
	| descriptor |
	descriptor := system descriptorFor: anObject.
	descriptor isNil ifTrue: [^nil].

	^rowMap rowForTable: descriptor table withKey: anObject.
]

{ #category : #running }
GlorpMappingTest >> setUp [

	super setUp.
	rowMap := RowMap new
]

{ #category : #tests }
GlorpMappingTest >> testManyToMany [

	| customer customerTable accountTable linkTable linkRow |
	customer := GlorpBankExampleSystem new objectNumber: 1 ofClass: GlorpCustomer.
	rowMap := RowMap new.
	customerTable := system tableNamed: 'GR_CUSTOMER'.
	accountTable := system tableNamed: 'BANK_ACCT'.
	linkTable := system tableNamed: 'CUSTOMER_ACCT_LINK'.

	self write: customer.
	customer accounts do: [:each |
		self write: each].

	self assert: (rowMap includesRowForTable: customerTable withKey: customer).
	customer accounts do: [:each |
		self assert: (rowMap includesRowForTable: accountTable withKey: each).
		self assert: (rowMap includesRowForTable: linkTable withKey: (RowMapKey new key1: customer; key2: each))].

	customer accounts do: [:each | | rowMapKey |
		self assert: ((self rowFor: each) at: (accountTable fieldNamed: 'ID')) equals: each id.
		rowMapKey := RowMapKey new key1: customer; key2: each.
		linkRow := rowMap rowForTable: linkTable withKey: rowMapKey.
		self assert: (linkRow at: (linkTable fieldNamed: 'ACCT_ID')) equals: each id.
		self assert: (linkRow at: (linkTable fieldNamed: 'CUSTOMER_ID')) equals: customer id.
		].
	self assert: ((self rowFor: customer) at: (customerTable fieldNamed: 'ID')) equals: customer id.
	self assert: (rowMap numberOfEntriesForTable: linkTable) equals: 2.
	self assert: (rowMap numberOfEntriesForTable: customerTable) equals: 1
]

{ #category : #tests }
GlorpMappingTest >> testMergedOneToOne [
	self helperForMergedOneToOneReversingWriteOrder: false
]

{ #category : #tests }
GlorpMappingTest >> testMergedOneToOneReversingWrites [
	self helperForMergedOneToOneReversingWriteOrder: true
]

{ #category : #tests }
GlorpMappingTest >> testMissingDescriptor [
	self assert: (system descriptorFor: nil) isNil.
	self assert: (system descriptorFor: UndefinedObject) isNil.
	self assert: (system descriptorFor: 3) isNil
]

{ #category : #tests }
GlorpMappingTest >> testMultipleTableCreation [

	| descriptor table passenger table2 row1 row2 |
	descriptor := system descriptorFor: GlorpPassenger.
	passenger := GlorpPassenger example1.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PASSENGER'.
	table2 := system existingTableNamed: 'FREQUENT_FLYER'.
	descriptor createRowsFor: passenger in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: passenger).
	self assert: (rowMap includesRowForTable: table2 withKey: passenger).
	row1 := rowMap rowForTable: table withKey: passenger.
	self assert: (row1 at: (table fieldNamed: 'ID')) equals: passenger id.
	self assert: (row1 at: (table fieldNamed: 'NAME')) equals: passenger name.
	row2 := rowMap rowForTable: table2 withKey: passenger.
	self assert: (row2 at: (table2 fieldNamed: 'ID')) equals: passenger id.
	self assert: (row2 at: (table2 fieldNamed: 'POINTS')) equals: passenger frequentFlyerPoints.
	self assert: rowMap numberOfEntries equals: 3
]

{ #category : #tests }
GlorpMappingTest >> testMultipleTableCreationWithOneMissing [

	| descriptor table passenger table2 row1 |
	descriptor := system descriptorFor: GlorpPassenger.
	passenger := GlorpPassenger example1.
	passenger frequentFlyerPoints: nil.
	passenger airline: nil.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PASSENGER'.
	table2 := system existingTableNamed: 'FREQUENT_FLYER'.
	descriptor createRowsFor: passenger in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: passenger).
	self deny: (rowMap includesRowForTable: table2 withKey: passenger).
	row1 := rowMap rowForTable: table withKey: passenger.
	self assert: (row1 at: (table fieldNamed: 'ID')) equals: passenger id.
	self assert: (row1 at: (table fieldNamed: 'NAME')) equals: passenger name.
	self assert: rowMap numberOfEntries equals: 1
]

{ #category : #tests }
GlorpMappingTest >> testNestedMergedOneToOne [
	self helperForNestedMergedOneToOneReversingWriteOrder: false
]

{ #category : #tests }
GlorpMappingTest >> testNestedMergedOneToOneReversingWriteOrder [
	self helperForNestedMergedOneToOneReversingWriteOrder: true.
]

{ #category : #tests }
GlorpMappingTest >> testNilOneToOne [

	| person  personTable addressTable |
	person := GlorpPerson example1.
	person address: nil.
	self write: person.
	self write: person address.
	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self deny: (rowMap includesRowForTable: addressTable withKey: person address).

	self assert: rowMap numberOfEntries equals: 1
]

{ #category : #tests }
GlorpMappingTest >> testOneToMany [

	| customer customerTable transactionTable |
	customer := GlorpCustomer example1.
	rowMap := RowMap new.
	customerTable := system tableNamed: 'GR_CUSTOMER'.
	transactionTable := system tableNamed: 'BANK_TRANS'.
	self write: customer.
	customer transactions do: [:each |
		self write: each].

	self assert: (rowMap includesRowForTable: customerTable withKey: customer).
	customer transactions do: [:each |
		self assert: (rowMap includesRowForTable: transactionTable withKey: each)].

	customer transactions do: [:each |
		self assert: ((self rowFor: each) at: (transactionTable fieldNamed: 'OWNER_ID')) equals: customer id].
	self assert: ((self rowFor: customer) at: (customerTable fieldNamed: 'ID')) equals: customer id
]

{ #category : #tests }
GlorpMappingTest >> testOneToOne [

	| person  personTable addressTable |
	person := GlorpPerson example1.
	self write: person.
	self write: person address.
	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self assert: (rowMap includesRowForTable: addressTable withKey: person address).

	self assert: ((self rowFor: person address) at: (addressTable fieldNamed: 'ID')) equals: person address id.
	self assert: ((self rowFor: person) at: (personTable fieldNamed: 'ADDRESS_ID')) equals: person address id.
	self assert: rowMap numberOfEntries equals: 2
]

{ #category : #tests }
GlorpMappingTest >> testOneToOneWithProxy [

	| person  personTable addressTable proxy stub |
	person := GlorpPerson example1.
	proxy := Proxy new.
	proxy session: GlorpSession new.
	stub := GlorpQueryStub readOneOf: GlorpAddress where: [:address | address id = 1].
	stub result: person address.
	proxy query: stub.
	person address: proxy.
	self deny: person address isInstantiated.

	self write: person.

	personTable := system existingTableNamed: 'PERSON'.
	addressTable := system existingTableNamed: 'GR_ADDRESS'.

	self assert: (rowMap includesRowForTable: personTable withKey: person).
	self deny: (rowMap includesRowForTable: addressTable withKey: person address).

	self deny: ((self rowFor: person) hasValueFor: (personTable fieldNamed: 'ADDRESS_ID')).
	self assert: rowMap numberOfEntries equals: 1.
]

{ #category : #tests }
GlorpMappingTest >> testRowCreation [

	| descriptor person row table  |
	descriptor := system descriptorFor: GlorpPerson.
	person := GlorpPerson example1.
	rowMap := RowMap new.
	table := system existingTableNamed: 'PERSON'.
	descriptor createRowsFor: person in: rowMap.
	self assert: (rowMap includesRowForTable: table withKey: person).
	row := rowMap rowForTable: table withKey: person.
	self assert: (row at: (table fieldNamed: 'ID')) equals: person id.
	self assert: (row at: (table fieldNamed: 'NAME')) equals: person name.
	self assert: rowMap numberOfEntries equals: 2
]

{ #category : #support }
GlorpMappingTest >> write: anObject [

	| descriptor |
	descriptor := system descriptorFor: anObject. 
	descriptor isNil ifTrue: [^self].
	descriptor createRowsFor: anObject in: rowMap.
]
