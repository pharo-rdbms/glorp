Class {
	#name : #GlorpExpressionTest,
	#superclass : #GlorpDatabaseBasedTest,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #asserting }
GlorpExpressionTest >> assertIdentityOf: aBlock and: anotherBlock [

	| base |
	base := BaseExpression new.
	self
		assert: (aBlock asGlorpExpressionOn: base)
		identicalTo: (anotherBlock asGlorpExpressionOn: base)
]

{ #category : #asserting }
GlorpExpressionTest >> denyIdentityOf: aBlock and: anotherBlock [

	| base |
	base := BaseExpression new.
	self
		deny: (aBlock asGlorpExpressionOn: base)
		identicalTo: (anotherBlock asGlorpExpressionOn: base)
]

{ #category : #tests }
GlorpExpressionTest >> testAndOperation [

	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [ :a | a firstName = fred & (a firstName ~= fred) ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: RelationExpression.
	self assert: expression relation equals: #AND
]

{ #category : #tests }
GlorpExpressionTest >> testAndOperation2 [

	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [ :a | a firstName = fred AND: a firstName ~= fred ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: RelationExpression.
	self assert: expression relation equals: #AND
]

{ #category : #tests }
GlorpExpressionTest >> testAnySatisfyExists [

	| expression base |
	system useJoinsForAnySatisfy: false.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	expression := [ :a | a items anySatisfy: [ :each | each id = 7 ] ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: SubSelectExpression
]

{ #category : #tests }
GlorpExpressionTest >> testAnySatisfyJoin [

	| expression base |
	system useJoinsForAnySatisfy: true.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	expression := [ :a | a items anySatisfy: [ :each | each id = 7 ] ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: CollectionExpression.
	self
		assert: expression leftChild
		identicalTo: expression rightChild leftChild base
]

{ #category : #tests }
GlorpExpressionTest >> testAnySatisfyPrintExists [

	| expression |
	system useJoinsForAnySatisfy: false.
	expression := [ :cust |
	              cust transactions anySatisfy: [ :each | each id = 7 ] ]
		              asGlorpExpressionForDescriptor:
		              (system descriptorFor: GlorpCustomer).
	self assert:
		(' EXISTS (SELECT s1t1.ID<n> FROM BANK_TRANS s1t1<n> WHERE *s1t1.ID = ?* AND *s1t2.ID = s1t1.OWNER_ID)*'
			 expandMacros withUnixLineEndings match:
			 expression sqlString withUnixLineEndings)
]

{ #category : #tests }
GlorpExpressionTest >> testAnySatisfyPrintJoin [

	| expression |
	system useJoinsForAnySatisfy: true.
	expression := [ :cust |
	              cust transactions anySatisfy: [ :each | each id = 7 ] ]
		              asGlorpExpressionForDescriptor:
		              (system descriptorFor: GlorpCustomer).
	self
		assert: '(BANK_TRANS.ID = 7)'
		equalsIgnoringOuterBrackets: expression sqlString
]

{ #category : #tests }
GlorpExpressionTest >> testBetweenAnd [

	| expression base |
	base := BaseExpression new.
	expression := [ :a | a between: 3 and: 4 ] asGlorpExpressionOn: base.
	self assert: expression class identicalTo: InfixFunction.
	self assert: expression name equals: 'BETWEEN AND'.
	self
		assert: (expression arguments collect: [ :each | each value ])
		equals: (Array with: 3 with: 4)
]

{ #category : #tests }
GlorpExpressionTest >> testEqualityOperation [

	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [ :a | a firstName = fred ] asGlorpExpressionOn: base.
	self assert: expression leftChild identicalTo: (base get: #firstName).
	self
		assert: expression rightChild class
		identicalTo: ConstantExpression.
	self assert: expression rightChild value identicalTo: fred.
	self assert: expression relation identicalTo: #=
]

{ #category : #tests }
GlorpExpressionTest >> testFindingMapping [

	| base baseDescriptor |
	baseDescriptor := system descriptorFor: GlorpBankTransaction.
	base := BaseExpression new descriptor: baseDescriptor.
	self
		assert: (base get: #serviceCharge) mapping
		identicalTo:
		(baseDescriptor mappingForAttributeNamed: #serviceCharge).
	self
		assert: (base get: #serviceCharge) sourceDescriptor
		identicalTo: (system descriptorFor: GlorpBankTransaction).
	self
		assert: (base get: #serviceCharge) descriptor
		identicalTo: (system descriptorFor: GlorpServiceCharge)
]

{ #category : #tests }
GlorpExpressionTest >> testGetField [

	| expression |
	expression := [:cust | cust getField: 'ID'] asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	self assert: expression sqlString equals: 'GR_CUSTOMER.ID'.
	self assert: expression class equals: FieldExpression.
	self assert: expression field table equals: (system tableNamed: 'GR_CUSTOMER')
]

{ #category : #tests }
GlorpExpressionTest >> testGetFieldAmbiguous [

	self
		should: [
			[ :pass | pass getField: 'ID' ] asGlorpExpressionForDescriptor:
				(system descriptorFor: GlorpPassenger) ]
		raise: Dialect error
]

{ #category : #tests }
GlorpExpressionTest >> testGetFieldFromSecondaryTable [

	| expression |
	expression := [:pass | pass getField: 'POINTS']
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpPassenger).
	self assert: expression sqlString equals: 'FREQUENT_FLYER.POINTS'.
	self assert: expression class equals: FieldExpression.
	self assert: expression field table equals: (system tableNamed: 'FREQUENT_FLYER')
]

{ #category : #tests }
GlorpExpressionTest >> testIsNullPrint [

	| expression stream |
	expression := [:cust | cust id = nil]
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	stream := DatabaseCommand new session: system session.
	expression printSQLOn: stream withParameters: Dictionary new.
	self assert: '(GR_CUSTOMER.ID IS NULL)' equalsIgnoringOuterBrackets: expression sqlString
]

{ #category : #tests }
GlorpExpressionTest >> testJoinOperation [

	| userExpression base expression addressTable personTable query field1 field2 join |
	addressTable := system tableNamed: 'GR_ADDRESS'.
	personTable := system tableNamed: 'PERSON'.
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpPerson).
	userExpression := [ :aPerson | aPerson address number = 12 ]
		                  asGlorpExpressionOn: base.
	query := SimpleQuery readOneOf: GlorpPerson where: userExpression.
	query session: (GlorpSession new system: system).
	self
		assert: (userExpression additionalExpressionsIn: query) size
		equals: 1.
	query prepare.
	expression := query whereClause.
	self assert: query joins size equals: 1.
	join := query joins first.
	self
		assert: expression identicalTo: userExpression;
		assert: expression relation identicalTo: #=.
	field1 := join leftChild field.
	self assert: field1 table parent identicalTo: personTable.
	self assert: field1 name equals: 'ADDRESS_ID'.
	field2 := join rightChild field.
	self assert: field2 table parent identicalTo: addressTable.
	self assert: field2 name equals: 'ID'
]

{ #category : #'tests - mapping' }
GlorpExpressionTest >> testMappingBase [

	| base |
	base := BaseExpression new.
	self assert: (base get: #someAttribute) base == base
]

{ #category : #'tests - mapping' }
GlorpExpressionTest >> testMappingExpressionIdentity [
 
	self assertIdentityOf: [:a | a someAttribute] and: [:a | a someAttribute].
]

{ #category : #'tests - mapping' }
GlorpExpressionTest >> testMappingExpressionIdentity2 [

	self assertIdentityOf: [:a | a perform: #someAttribute] and: [:a | a someAttribute].
]

{ #category : #'tests - mapping' }
GlorpExpressionTest >> testMappingExpressionIdentity3 [

	self assertIdentityOf: [:a | a get: #someAttribute] and: [:a | a someAttribute].
]

{ #category : #'tests - mapping' }
GlorpExpressionTest >> testMappingExpressionIdentity4 [

	self denyIdentityOf: [:a | a get: #someAttribute] and: [:a | a someOtherAttribute].
]

{ #category : #tests }
GlorpExpressionTest >> testNotNullPrint [

	| expression stream |
	expression := [:cust | cust id ~= nil]
		asGlorpExpressionForDescriptor: (system descriptorFor: GlorpCustomer).
	stream := DatabaseCommand new session: system session.
	expression printSQLOn: stream withParameters: Dictionary new.
	self assert: '(GR_CUSTOMER.ID IS NOT NULL)' equalsIgnoringOuterBrackets: stream contents
]

{ #category : #tests }
GlorpExpressionTest >> testOrOperation [

	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [ :a | a firstName = fred | (a firstName ~= fred) ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: RelationExpression.
	self assert: expression relation equals: #OR
]

{ #category : #tests }
GlorpExpressionTest >> testOrOperation2 [

	| expression fred base |
	fred := 'Fred'.
	base := BaseExpression new.
	expression := [ :a | a firstName = fred OR: a firstName ~= fred ]
		              asGlorpExpressionOn: base.
	self assert: expression class identicalTo: RelationExpression.
	self assert: expression relation equals: #OR
]

{ #category : #tests }
GlorpExpressionTest >> testTwoLevelMappingExpressionIdentity [

	self assertIdentityOf: [:a | a someAttribute someAttribute ] and: [:a | a someAttribute someAttribute ].
	self denyIdentityOf: [:a | a someAttribute someAttribute ] and: [:a | a someAttribute ]
]
