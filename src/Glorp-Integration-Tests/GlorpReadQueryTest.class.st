Class {
	#name : #GlorpReadQueryTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'session'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #resources }
GlorpReadQueryTest class >> resources [

	^Array with: GlorpSessionResource.
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> helpTestSingleOrderingBy: aBlock setup: setupBlock [

	| query result realBlock |
	query := Query read: GlorpAddress.
	query orderBy: aBlock.
	realBlock := query expressionBlockFor: aBlock.
	result := session execute: query.
	self verifyOrderFor: result byAttribute: realBlock.
]

{ #category : #support }
GlorpReadQueryTest >> setUp [

	super setUp.
	session := GlorpSessionResource current newSession.
	session system: (GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database).
	session beginTransaction.
	self writeAddressDoubleOrderingRows.
	self writePersonOrderingRows.
]

{ #category : #support }
GlorpReadQueryTest >> tearDown [

	super tearDown.
	session rollbackTransaction.
	session reset.
	session := nil.
]

{ #category : #tests }
GlorpReadQueryTest >> testCriteriaSetup [
	| query |
	query := Query readOneOf: GlorpAddress where: [:each | each id = 12].
	query session: session.
	query setUpExpressions.
	self assert: query whereClause class == RelationExpression.
	self assert: query whereClause ultimateBaseExpression descriptor 
				== (session descriptorFor: GlorpAddress)
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testDescendingSingleOrdering [
	| query result sortedResult |
	
	query := Query read: GlorpAddress where: [:each | each street ~= 'Beta'].
	query orderBy: [:each | each street descending].
	result := session execute: query.
	sortedResult := result 
				asSortedCollection: [:a :b | a street > b street].
	self assert: sortedResult asArray = result asArray.
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testDoubleOrderingAddress [
	| query |
	query := Query read: GlorpAddress.
	query orderBy: [:each | each street].
	query orderBy: [:each | each number].
	self validateDoubleOrderFor: query.
]

{ #category : #tests }
GlorpReadQueryTest >> testIn [
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each street in: #('Beta' 'Alpha')].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | #('Beta' 'Alpha') includes: each street]).
	self assert: result size = 4.
]

{ #category : #tests }
GlorpReadQueryTest >> testInEmpty [
	"This test generates an error in DB2 because DB2 claims that IN (NULL) is invalid,
	since not even NULL can be IN (NULL) (since NULL isn't equal to itself)."

	| query result |
	session platform isDB2Platform ifTrue: [^self].
	query := Query read: GlorpAddress where: [:each | each street in: #()].
	result := session execute: query.
	self assert: result isEmpty
]

{ #category : #tests }
GlorpReadQueryTest >> testInInteger [
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each id in: #(1 2)].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | #(1 2) includes: each id]).
	self assert: result size = 2.
]

{ #category : #tests }
GlorpReadQueryTest >> testInSymbol [
	| query result transRow transRow2 |
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.	
	transRow2 := session system exampleBankTransactionRow2.
	session writeRow: transRow2.	
	query := Query read: GlorpBankTransaction where: [:each | each amount currency in: #(#USD #CDN)].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each amount currency = #CDN]).
	self assert: result size = 1.
	query := Query read: GlorpBankTransaction where: [:each | each amount currency in: #(#USD #DM)].
	result := session execute: query.
	self assert: result isEmpty.
]

{ #category : #tests }
GlorpReadQueryTest >> testLike [
	| query result |
	
	query := Query read: GlorpAddress where: [:each | each street like: 'Be%'].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each street = 'Beta']).
	self assert: result size = 3.
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testMixedDoubleOrderingAddress [
	| query |
	query := Query read: GlorpAddress.
	query orderBy: [:each | each street descending].
	query orderBy: [:each | each number].
	self validateDoubleOrderMixedFor: query.
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testOrderingByRelatedObjectAttribute [
	| query result |
	query := Query read: GlorpPerson.
	query orderBy: [:each | each address street].
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testOrderingWithNonEmptyWhereClause [

	| query result |
	query := Query read: GlorpPerson where: [:each | each id ~= 12].
	query orderBy: #(#address #street).
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadDataItemsFromEmbeddedObject [

	| query result transRow id |
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	id := transRow atFieldNamed: 'ID'.
	query := Query read: GlorpBankTransaction.
	query retrieve: [:each | each id].
	query retrieve: [:each | each serviceCharge description].
	result := query executeIn: session.
	self assert: result size = 1.
	self assert: result first = (Array with: id with: 'additional overcharge').
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadDistinctIds [

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id distinct].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadDistinctIdsWithWhereClause [

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id distinct].
	query whereClause: [:each | each id ~= 423421].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadDistinctRelatedAttribute [

	| query result allStreets |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each address street distinct].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #('Alpha' 'Beta' 'Gamma')).
	allStreets := (session read: GlorpAddress) collect: [:each | each street].
	self assert: allStreets size = 5.
]

{ #category : #tests }
GlorpReadQueryTest >> testReadMultipleObjects [

	| query result tracing addressReadSeparately personReadSeparately allResults |
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each ].
	tracing retrieve: [:each | each address].
	query tracing: tracing.
	query orderBy: #id.
	allResults := query executeIn: session.
	self assert: allResults size = 3.
	result := allResults first.
	self assert: (result at: 1) id = 86.
	self assert: ((result at: 1) class == GlorpPerson).
	self assert: (result at: 1) address == (result at: 2).
	self assert: ((result at: 2) class == GlorpAddress).
	self assert: ((result at: 2) id = 2).
	addressReadSeparately := session readOneOf: GlorpAddress where: [:each | each id = 2].
	self assert: result last == addressReadSeparately.
	personReadSeparately := session readOneOf: GlorpPerson where: [:each | each id = 86].
	self assert: personReadSeparately == result first.
	self assert: personReadSeparately address yourSelf == result last.
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadObjectsAndData [

	| query result tracing addressReadSeparately personReadSeparately |
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each address].
	query tracing: tracing.
	query orderBy: #id.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result first at: 1) = 86.
	self assert: ((result first at: 2) class == GlorpAddress).
	self assert: ((result first at: 2) id = 2).
	addressReadSeparately := session readOneOf: GlorpAddress where: [:each | each id = 2].
	self assert: result first last == addressReadSeparately.
	personReadSeparately := session readOneOf: GlorpPerson where: [:each | each id = 86].
	self assert: personReadSeparately address yourSelf == result first last.
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadOneWithObjects [

	| query result |
	query := Query readOneOf: GlorpPerson where: [:each | each id = 86].
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query orderBy: [:each | each id].
	result := query executeIn: session.
	self assert: result first id = 86.
	self assert: (result first address yourSelf == result last).
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadOnlyPrimaryKeys [

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each id].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #(86 87 88)).
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadTwoDataItems [

	| query result tracing|
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each name].
	query tracing: tracing.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result includes: #(86 'person1')).
	self assert: (result includes: #(87 'person2')).
	self assert: (result includes: #(88 'person3')).
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadTwoDataItemsFromDifferentObjects [

	| query result tracing|
	query := Query read: GlorpPerson.
	tracing := Tracing new.
	tracing retrieve: [:each | each id].
	tracing retrieve: [:each | each address street].
	query tracing: tracing.
	query orderBy: #id.
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: result first = #(86 'Beta').
	self assert: (result at: 2) = #(87 'Gamma').
	self assert: result last = #(88 'Alpha').
]

{ #category : #'tests-data reading' }
GlorpReadQueryTest >> testReadTwoObjects [

	| query result |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query orderBy: [:each | each id].
	result := query executeIn: session.
	self assert: result size = 3.
	self assert: (result first atIndex: 1) id = 86.
	self assert: ((result first atIndex: 1) address yourSelf == result first last).
]

{ #category : #tests }
GlorpReadQueryTest >> testReadWithFunctionInWhereClause [
	"The assertion on what we read doesn't matter too much, as we're primarily testing that the expression doesn't walkback."
	| people |
	people := session read: GlorpPerson where: [:each | each id + each id > 2].
	people do: [:each | self assert: (each id + each id) > 10].
	people := session read: GlorpPerson where: [:each | (each name , each address street) = 'person1Beta'].
	self assert: people size = 1.
	self assert: people first name = 'person1'.
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testSingleOrderingAddress1 [

	self 
		helpTestSingleOrderingBy: [:each | each street]
		setup: [self writeAddressOrderingRows].
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testSingleOrderingAddress2 [

	self 
		helpTestSingleOrderingBy: [:each | each number]
		setup: [self writeAddressOrderingRows].
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testSingleOrderingBySymbol [

	self 
		helpTestSingleOrderingBy: #street
		setup: [self writeAddressOrderingRows].
]

{ #category : #'tests-ordering' }
GlorpReadQueryTest >> testSymbolsOrderingByRelatedObjectAttribute [

	| query result |
	query := Query read: GlorpPerson.
	query orderBy: #(#address #street).
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].
]

{ #category : #support }
GlorpReadQueryTest >> validateDoubleOrderFor: query [ 
	| result sortedResult |
	result := session execute: query.
	sortedResult := result asSortedCollection: 
					[:a :b | 
					a street = b street 
						ifTrue: [a number <= b number]
						ifFalse: [a street < b street]].
	^self assert: sortedResult asArray = result asArray
]

{ #category : #support }
GlorpReadQueryTest >> validateDoubleOrderMixedFor: query [ 
	| result sortedResult |
	result := session execute: query.
	sortedResult := result asSortedCollection: 
					[:a :b | 
					a street = b street 
						ifTrue: [a number <= b number]
						ifFalse: [a street > b street]].
	^self assert: sortedResult asArray = result asArray
]

{ #category : #support }
GlorpReadQueryTest >> verifyOrderFor: result byAttribute: aBlock [
	1 to: result size - 1
		do: 
			[:i | 
			| a b |
			a := result at: i.
			b := result at: i + 1.
			self assert: (aBlock value: a) <= (aBlock value: b)]
]

{ #category : #support }
GlorpReadQueryTest >> writeAddressDoubleOrderingRows [

	self writeAddressOrderingRows.
	session writeRow: session system exampleAddressRowForOrdering4.
	session writeRow: session system exampleAddressRowForOrdering5.
]

{ #category : #support }
GlorpReadQueryTest >> writeAddressOrderingRows [

	session writeRow: session system exampleAddressRowForOrdering1.
	session writeRow: session system exampleAddressRowForOrdering2.
	session writeRow: session system exampleAddressRowForOrdering3.
]

{ #category : #support }
GlorpReadQueryTest >> writePersonOrderingRows [

	session writeRow: session system examplePersonRowForOrdering1.
	session writeRow: session system examplePersonRowForOrdering2.
	session writeRow: session system examplePersonRowForOrdering3.
]
