Class {
	#name : #GlorpDescriptorTest,
	#superclass : #GlorpDatabaseBasedTest,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpDescriptorTest >> errorSignal [

	^Dialect error.
]

{ #category : #tests }
GlorpDescriptorTest >> testAllClassesAndNames [
	| identity1 identity2 identity3 |
	system flushAllClasses.
	identity1 := system allClasses.
	identity2 := system allClasses.
	system flushAllClasses.
	identity3 := system allClasses.
	self assert: identity1 == identity2.
	self assert: identity1 ~~ identity3.
	self should: [system allClassNames] raise: Dialect error.
]

{ #category : #tests }
GlorpDescriptorTest >> testAllMappingsForField [

	| descriptor mappings |
	descriptor := system descriptorFor: GlorpCustomer.
	mappings := descriptor
				allMappingsForField: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	self assert: mappings first attributeName equals: #id
]

{ #category : #tests }
GlorpDescriptorTest >> testBuildBankTransactionAndDependentsFromRow [

	| transactionDescriptor object row moneyDescriptor money1 table translations session builder |
	session := GlorpMockSession new.
	session system: system.
	transactionDescriptor := system descriptorFor: GlorpBankTransaction.
	object := GlorpBankTransaction new.
	row := #(99 nil 'CDN' 98 'service charge' 'USD' 97).
	builder := ObjectBuilder new.
	builder row: row.
	transactionDescriptor populateObject: object inBuilder: builder.
	self assert: object id equals: 99.
	moneyDescriptor := system descriptorFor: GlorpMoney.
	money1 := GlorpMoney new.
	table := system tableNamed: 'MONEY_IMAGINARY_TABLE'.
	translations := IdentityDictionary new.
	translations at: (table fieldNamed: 'CURRENCY') put: 3.
	translations at: (table fieldNamed: 'AMOUNT') put: 4.
	builder := ElementBuilder new fieldTranslations: translations; row: row.
	moneyDescriptor
		populateObject: money1
		inBuilder: builder.
	self assert: money1 amount = 98.
	self assert: money1 currency = #CDN.
]

{ #category : #tests }
GlorpDescriptorTest >> testBuildPersonFromRow [

	| descriptor object address session builder |
	session := GlorpMockSession new.
	session system: system.
	address := GlorpAddress new.
	session cacheAt: 127 put: address.
	descriptor := system descriptorFor: GlorpPerson.
	system tableNamed: 'PERSON'.
	object := GlorpPerson new.
	builder := ObjectBuilder new.
	builder row: #(456 'Ralph' 127).
	descriptor populateObject: object inBuilder: builder.
	self assert: object class equals: GlorpPerson.
	self assert: object id equals: 456.
	self assert: object name = 'Ralph'.
	self assert: object address getValue == address
]

{ #category : #tests }
GlorpDescriptorTest >> testDescriptorIdentity [

	| descriptor |
	descriptor := system descriptorFor: GlorpCustomer.
	self assert: descriptor == (system descriptorFor: GlorpCustomer).
]

{ #category : #tests }
GlorpDescriptorTest >> testMappedFields [

	| descriptor |
	descriptor := system descriptorFor: GlorpBankTransaction.
	self assert: (descriptor mappedFields) equals: (descriptor table fields).
]

{ #category : #tests }
GlorpDescriptorTest >> testMappingForField [
	| descriptor mapping |
	descriptor := system descriptorFor: GlorpCustomer.
	mapping := descriptor 
				directMappingForField: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	self assert: mapping attributeName equals: #id
]

{ #category : #tests }
GlorpDescriptorTest >> testPrimaryKeyExpressionFor [
	| descriptor trans exp |
	descriptor := system descriptorFor: GlorpBankTransaction.
	trans := GlorpBankTransaction new.
	trans id: 42.
	exp := descriptor
		primaryKeyExpressionFor: trans
		basedOn: BaseExpression new
		relation: #=.
	self assert: exp relation equals: #=.
	self assert: exp rightChild value equals: 42.
]

{ #category : #tests }
GlorpDescriptorTest >> testPrimaryKeyExpressionForFailing [
	| descriptor trans |
	descriptor := system descriptorFor: GlorpBankTransaction.
	trans := GlorpCustomer new.
	self
		should:
			[descriptor
				primaryKeyExpressionFor: trans
				basedOn: BaseExpression new
				relation: #=]
		raise: self errorSignal.
]

{ #category : #tests }
GlorpDescriptorTest >> testPrimaryKeyExpressionForWithCompositeKey [

	self unfinished.
]
