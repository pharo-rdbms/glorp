tests
helperForNestedMergedOneToOneReversingWriteOrder: aBoolean 
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