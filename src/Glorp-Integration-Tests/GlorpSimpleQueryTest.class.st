Class {
	#name : #GlorpSimpleQueryTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpSimpleQueryTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #running }
GlorpSimpleQueryTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession
]

{ #category : #tests }
GlorpSimpleQueryTest >> setUpQueryBasic: query [ 
	| |
	query session: session.
	query setUpExpressions.
	query setupTracing.
]

{ #category : #tests }
GlorpSimpleQueryTest >> setUpQueryFields: query [ 
	self setUpQueryBasic: query.
	query computeFields.
]

{ #category : #tests }
GlorpSimpleQueryTest >> setUpQueryFully: query [ 
	self setUpQueryBasic: query.
	query prepare
]

{ #category : #tests }
GlorpSimpleQueryTest >> skipToString [
	^session platform supportsANSIJoins ifTrue: ['join '] ifFalse: ['where '].
]

{ #category : #running }
GlorpSimpleQueryTest >> tearDown [

	session reset.
	session := nil.
	super tearDown
]

{ #category : #tests }
GlorpSimpleQueryTest >> testCaseInsensitiveQuery [
	| result |
	session platform supportsCaseInsensitiveLike ifFalse: [^self].
	[session beginUnitOfWork.
	session beginTransaction.
	session register: GlorpAddress example1.
	session commitUnitOfWork.
	result := session
				readOneOf: GlorpAddress
				where: [:address | address street ilike: 'WeSt%'].
	self assert: result street = 'West 47th Ave'] 
			ensure: [session rollbackTransaction]
]

{ #category : #tests }
GlorpSimpleQueryTest >> testComputingFieldsForDirectMappings [

	| query table |
	query := SimpleQuery readOneOf: GlorpAddress where: [:each | each id = 1].
	self setUpQueryFields: query.
	
	table := session system tableNamed: 'GR_ADDRESS'.
	self assert: (query fields = table fields).
]

{ #category : #tests }
GlorpSimpleQueryTest >> testComputingFieldsForDirectMappingsWithFullPrepare [

	| query table |
	query := Query readOneOf: GlorpAddress where: [:each | each id = 1].
	query session: session.
	query prepare.
	
	table := session system tableNamed: 'GR_ADDRESS'.
	self assert: ((query fields collect: [:each | each table parent fieldNamed: each name])= table fields).
]

{ #category : #tests }
GlorpSimpleQueryTest >> testComputingFieldsForReferenceMappings [

	| query table |
	query := SimpleQuery readOneOf: GlorpPerson where: [:each | each id = 1].
	self setUpQueryFields: query.
	
	table := session system tableNamed: 'PERSON'.
	self assert: (query fields = table fields).
]

{ #category : #tests }
GlorpSimpleQueryTest >> testComputingFieldsForReferenceMappingsWithFullPrepare [

	| query table |
	query := SimpleQuery readOneOf: GlorpPerson where: [:each | each id = 1].
	query session: session.
	query prepare.
	
	table := session system tableNamed: 'PERSON'.
	self assert: ((query fields collect: [:each | each table parent fieldNamed: each name])= table fields).
]

{ #category : #tests }
GlorpSimpleQueryTest >> testDescriptorAssignmentToCriteria [

	| query |
	query := SimpleQuery readOneOf: GlorpAddress where: [:each | each id = 1].
	query session: session.
	query setUpExpressions.
	self assert: query whereClause ultimateBaseExpression descriptor == (session descriptorFor: GlorpAddress).
]

{ #category : #'tests-ordering' }
GlorpSimpleQueryTest >> testDoubleOrderSQL [
	| query sql |
	query := SimpleQuery read: GlorpAddress.
	query orderBy: [:each | each id].
	query orderBy: [:each | each number].
	self setUpQueryFully: query.
	sql := (query sqlWith: Dictionary new) sqlString.
	self assert: ('* from *gr_address t1 order by t1.id, t1.house_num' match: sql asLowercase).
]

{ #category : #tests }
GlorpSimpleQueryTest >> testFieldAliasingForEmbeddedMappings [

	| query table |
	query := SimpleQuery readOneOf: GlorpBankTransaction where: [:each | each id = 1].
	self setUpQueryFields: query.
	table := session system tableNamed: 'BANK_TRANS'.
	self assert: (query fields = table fields).
	self assert: (query builders first translateFieldPosition: (table fieldNamed: 'ID')) = 1.
	self assert: (query builders first translateFieldPosition: (table fieldNamed: 'OWNER_ID')) = 2.
]

{ #category : #tests }
GlorpSimpleQueryTest >> testJoinExpressionWithMultipleTables [
	| query sql sqlStream result command |
	query := SimpleQuery readOneOf: GlorpPassenger where: [ :each | each id = 1 ].
	query session: session.
	query prepare.
	command := query sqlWith: Dictionary new.
	command useBinding: false.
	sql := command sqlString.
	sqlStream := ReadStream on: sql asLowercase.
	sqlStream skipToAll: self skipToString.
	result := sqlStream upToEnd.
	session platform supportsANSIJoins
		ifTrue:
			[ self
				assert: ('*frequent_flyer t2 on *t1.id = t2.id*<n> where *t1.id = 1*' expandMacros withUnixLineEndings match: result withUnixLineEndings) ]
		ifFalse: [ self assert: ('*(t1.id = 1) and ((t1.id = t2.id*' match: result) ]
]

{ #category : #'tests-ordering' }
GlorpSimpleQueryTest >> testOrderSQL [
	| query sql |
	query := SimpleQuery read: GlorpAddress.
	query orderBy: [:each | each id].
	self setUpQueryFully: query.
	sql := (query sqlWith: Dictionary new) sqlString.
	self assert: ('* from *gr_address t1 order by t1.id' match: sql asLowercase).
]
