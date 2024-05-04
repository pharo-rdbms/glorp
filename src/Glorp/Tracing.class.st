"
A tracing is a collection of expressions representing the graph of other objects which
are to be read at the same time as the root object.

Instance Variables:

	base	<Expression>	The base expression representing the root object. Same as the parameter to the query block
	allTracings	<Collection of: Expression>	The expressions representing each of the associated objects. e.g. base accounts, base amount serviceCharge .
	alsoFetchExpressions	<(Collection of: GlorpExpression)>	Objects to also retrieve, but not included in the result set, just knitted together with the other related objects.
	retrievalExpressions	<(Collection of: GlorpExpression)>	Objects to also retrieve, and to include in the result set


"
Class {
	#name : 'Tracing',
	#superclass : 'Object',
	#instVars : [
		'base',
		'allTracings',
		'retrievalExpressions',
		'alsoFetchExpressions',
		'query'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'instance creation' }
Tracing class >> for: aQuery [
	^self new base: aQuery whereClause ultimateBaseExpression
]

{ #category : 'accessing' }
Tracing >> addExpression: anExpression [
	self addExpression: anExpression andDo: [:ignore |]
]

{ #category : 'accessing' }
Tracing >> addExpression: anExpression andDo: aBlock [
	| exp |
	exp := anExpression asGlorpExpressionOn: self base in: query.
	(allTracings includes: exp) ifFalse: [
		allTracings add: exp.
		aBlock value: exp]
]

{ #category : 'accessing' }
Tracing >> additionalExpressions [
	| all |
	alsoFetchExpressions isEmpty ifTrue: [^retrievalExpressions].
	all := OrderedCollection new.
	all addAll: self retrievalExpressions.
	all addAll: self alsoFetchExpressions.
	^all.
]

{ #category : 'accessing' }
Tracing >> allTracings [

	^allTracings
]

{ #category : 'api' }
Tracing >> alsoFetch: anExpression [ 
	"Add the expression as something which will be explicitly retrieved and knit together with other results, but NOT included in the result list"

	self addExpression: anExpression andDo: [:exp |
		alsoFetchExpressions add: exp]
]

{ #category : 'accessing' }
Tracing >> alsoFetchExpressions [
	^alsoFetchExpressions
]

{ #category : 'accessing' }
Tracing >> base [
	^query isNil ifTrue: [base] ifFalse: [query baseExpression]
]

{ #category : 'accessing' }
Tracing >> base: anExpression [ 
	base := anExpression
]

{ #category : 'copying' }
Tracing >> copy [
	^self shallowCopy postCopy
]

{ #category : 'initialization' }
Tracing >> initialize [

	base := BaseExpression new.
	allTracings := OrderedCollection new: 2.
	retrievalExpressions := Set new: 3.
	alsoFetchExpressions := Set new: 3
]

{ #category : 'copying' }
Tracing >> postCopy [
	allTracings := allTracings copy.
	retrievalExpressions := retrievalExpressions copy.
	alsoFetchExpressions := alsoFetchExpressions copy
]

{ #category : 'accessing' }
Tracing >> retrievalExpressions [
	^retrievalExpressions
]

{ #category : 'api' }
Tracing >> retrieve: anExpression [ 
	"Add the expression as something which will be explicitly retrieved and knit together with other results, and included in the result list"
	self addExpression: anExpression andDo: [:exp |
		retrievalExpressions add: exp]
]

{ #category : 'setup' }
Tracing >> setup [
	"We have been put into a query. If we aren't to trace anything else, trace the base"
	retrievalExpressions isEmpty ifTrue: [
		allTracings addFirst: base.
		retrievalExpressions add: base].
]

{ #category : 'querying' }
Tracing >> tracesThrough: aMapping [

	^aMapping isStoredInSameTable
]

{ #category : 'setup' }
Tracing >> updateBase: aBaseExpression [
	"Make sure we have the same base as the query"
	| transformed |
	transformed := IdentityDictionary new.
	base == aBaseExpression ifTrue: [^self].
	base := aBaseExpression.
	allTracings := allTracings collect: [:each | | new | new := each asGlorpExpressionOn: base.
		transformed at: each put: new.
		new].
	retrievalExpressions := retrievalExpressions collect: [:each | 
		transformed at: each].
	alsoFetchExpressions := alsoFetchExpressions collect: [:each | 
		transformed at: each]
]
