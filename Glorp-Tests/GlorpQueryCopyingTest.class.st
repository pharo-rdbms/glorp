Class {
	#name : #GlorpQueryCopyingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'query',
		'expression',
		'elementBuilder',
		'session',
		'newQuery'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #'as yet unclassified' }
GlorpQueryCopyingTest class >> resources [
	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpQueryCopyingTest >> setUp [
	super setUp.
	query := Query read: GlorpCustomer.
	query whereClause: [:each | each accounts anySatisfy: [:foo | foo id = 12]].
	session := GlorpSessionResource current newSession.
	query session: session.
]

{ #category : #'As yet unclassified' }
GlorpQueryCopyingTest >> tableAliasesPresentFor: aQuery [
	aQuery whereClause detect: [:each | each hasTableAliases] ifNone: [^false].
	^true.
]

{ #category : #tests }
GlorpQueryCopyingTest >> testExpressionTableAliases [
	query prepare.
	newQuery := query copy.
	self assert: (self tableAliasesPresentFor: query).
	self deny: (self tableAliasesPresentFor: newQuery).
]

{ #category : #tests }
GlorpQueryCopyingTest >> testPreparedness [
	self deny: query isPrepared.
	query prepare.
	newQuery := query copy.
	self assert: query isPrepared.
	self deny: newQuery isPrepared.
]
