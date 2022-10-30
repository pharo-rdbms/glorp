"
This is a query that has more than one subquery, combined by expressions like UNION ALL or INTERSECTION. It doesn't do all that much except print its subqueries and combine them according to the operation.

Instance Variables:
	operation	<String>	The name of the operation we are using to combine the queries.
	primaryQuery	<Query>	The first query that we contain. This determines what objects we actually return. All of the queries should match up in terms of what they return, or the database is unlikely to accept this as a valid query.
	queries	<(SequenceableCollection of: SimpleQuery)>	The queries we contain.
	specialBuilders <Array of: ElementBuilder> If we want to do something to modify our result, we can add our own set of builders here, which will be added to those of the internal queries. Motivating example is doing a horizontal inheritance query, where we can end up with one of N different objects in the row, and we just want to return that one directly.


"
Class {
	#name : #CompoundQuery,
	#superclass : #Query,
	#instVars : [
		'queries',
		'operation',
		'primaryQuery',
		'specialBuilders',
		'requiresDistinct',
		'limit',
		'offset'
	],
	#category : #'Glorp-Queries'
}

{ #category : #'instance creation' }
CompoundQuery class >> newIntersect [
	^self new operation: #INTERSECT
]

{ #category : #'instance creation' }
CompoundQuery class >> newMinus [
	^self new operation: #EXCEPT
]

{ #category : #'instance creation' }
CompoundQuery class >> newUnionAll [
	^self new operation: #'UNION ALL'
]

{ #category : #accessing }
CompoundQuery >> addQuery: aQuery [
	queries isEmpty ifTrue: [primaryQuery := aQuery].
	queries add: aQuery
]

{ #category : #accessing }
CompoundQuery >> baseExpression [
	^queries first baseExpression
]

{ #category : #preparing }
CompoundQuery >> copyOfBuilders [ 
	^primaryQuery copyOfBuilders
]

{ #category : #'boolean operations' }
CompoundQuery >> except: aQuery [
	^self minus: aQuery
]

{ #category : #executing }
CompoundQuery >> executeWithParameters: parameterArray in: aSession [
	session := aSession.
	^self 
		readFromDatabaseWithParameters: parameterArray
]

{ #category : #testing }
CompoundQuery >> hasLimit [

	^ self limit isNotNil
]

{ #category : #testing }
CompoundQuery >> hasOffset [

	^ self offset isNotNil
]

{ #category : #initializing }
CompoundQuery >> initialize [
	super initialize.
	requiresDistinct := true.
	queries := OrderedCollection new: 3.
]

{ #category : #testing }
CompoundQuery >> isIntersect [
	^operation = #INTERSECT.
]

{ #category : #testing }
CompoundQuery >> isMinus [
	^operation = 'EXCEPT'
]

{ #category : #testing }
CompoundQuery >> isUnionAll [
	^operation = #'UNION ALL'
]

{ #category : #accessing }
CompoundQuery >> joins [
	^queries inject: #() into: [:sum :each | sum, each joins]
]

{ #category : #accessing }
CompoundQuery >> limit [
	^limit
]

{ #category : #accessing }
CompoundQuery >> limit: anInteger [
	"We currently ignore limit sets and use the one from our contained queries."
	limit := anInteger
]

{ #category : #accessing }
CompoundQuery >> mightHaveDuplicateRows [
	^primaryQuery mightHaveDuplicateRows
]

{ #category : #'boolean operations' }
CompoundQuery >> minus: aQuery [
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	^CompoundQuery newMinus addQuery: self; addQuery: aQuery
]

{ #category : #accessing }
CompoundQuery >> offset [
	^ offset
]

{ #category : #accessing }
CompoundQuery >> offset: anInteger [
	"We currently ignore offset sets and use the one from our contained queries."
	offset := anInteger
]

{ #category : #accessing }
CompoundQuery >> operation: aString [
	operation := aString
]

{ #category : #copying }
CompoundQuery >> postCopy [

	super postCopy.
	queries := queries collect: [:each | each copy].
	primaryQuery := queries first.
]

{ #category : #preparing }
CompoundQuery >> prepare [
	| |
	queries do: [:each | each session: session].
	queries do: [:each | each prepare].
	ordering isNil ifFalse: [
		ordering := ordering collect: [:each |
			(self expressionBlockFor: each) asGlorpExpressionOn: queries first baseExpression]].
	grouping isNil ifFalse: [grouping := (self expressionBlockFor: grouping) asGlorpExpressionOn: queries first baseExpression]
]

{ #category : #accessing }
CompoundQuery >> primaryQuery: aQuery [
	primaryQuery := aQuery
]

{ #category : #printing }
CompoundQuery >> printCompoundSelectAliasesOn: aStream [
	"We only want one table. This is a somewhat convoluted way of getting 't1' uniformly appended"
	aStream nextPutAll: ' '.
	self session platform supportsAliasInCompoundQuery ifTrue: [
		primaryQuery tablesToPrint first printSQLOn: aStream withParameters: nil]
]

{ #category : #printing }
CompoundQuery >> printOffsetOn: aCommand [
	self hasOffset ifFalse: [^self].
	self platform printOffset: self offset on: aCommand
]

{ #category : #printing }
CompoundQuery >> printOperationOn: aCommand [
	aCommand space.
	aCommand nextPutAll: (self platform compoundOperationFor: operation).
	aCommand space
]

{ #category : #printing }
CompoundQuery >> printPostLimitOn: aCommand [
	self hasLimit ifFalse: [^self].
	self platform printPostLimit: self limit on: aCommand
]

{ #category : #accessing }
CompoundQuery >> proxyType [
	^primaryQuery proxyType
]

{ #category : #accessing }
CompoundQuery >> proxyType: aClass [	
	"We currently ignore proxy types and use the ones from our main query."
	^self
]

{ #category : #accessing }
CompoundQuery >> queries [
	^queries
]

{ #category : #accessing }
CompoundQuery >> queries: aCollectionOfQueries [
	queries := aCollectionOfQueries
]

{ #category : #executing }
CompoundQuery >> readFromDatabaseWithParameters: anArray [
	| answerStream result |
	answerStream := self rowsFromDatabaseWithParameters: anArray.
	^self readsOneObject
		ifTrue: [result := answerStream next. answerStream release. result]
		ifFalse: [self resultCollectionFor: answerStream]
]

{ #category : #accessing }
CompoundQuery >> requiresDistinct [
	^requiresDistinct
]

{ #category : #accessing }
CompoundQuery >> requiresDistinct: aBoolean [
	requiresDistinct := aBoolean
]

{ #category : #accessing }
CompoundQuery >> resultClass [
	^primaryQuery resultClass
]

{ #category : #'sql generation' }
CompoundQuery >> rewriteExcept [
	"Rewrite any EXCEPT operation we have into a NOT EXISTS test with a correlated subselect. Only a CompoundQuery would have an EXCEPT"
	
	| |
	operation == #EXCEPT ifFalse: [^self].
	queries := queries collect: [:each | each rewriteExcept].
	^self rewriteSetOperationUsing: #notExists:
]

{ #category : #'sql generation' }
CompoundQuery >> rewriteIntersect [
	"Rewrite any INTERSECT operation we have into an EXISTS test for a correlated subselect. Only a CompoundQuery would have an intersect"
	
	| |
	operation == #INTERSECT ifFalse: [^self].
	queries := queries collect: [:each | each rewriteIntersect].
	^self rewriteSetOperationUsing: #exists:
]

{ #category : #'sql generation' }
CompoundQuery >> rewriteSetOperationUsing: aSelector [
	"Rewrite any INTERSECT OR EXCEPT operation we have into a correlated EXISTS or NOT EXISTS test, respectively. We take the sub-query, and AND into it a constraint that its base expression is equal to the first queries base expression, and then do either an exists: or a notExists:, depending on aSelector."
	
	| newQuery |
	newQuery := queries first copy.
	2 to: queries size do: [:i | | q expression mainExpression |
		q := (queries at: i) copy.
		expression := RelationExpression new outerJoin: false; relation: #=; leftChild: newQuery baseExpression; rightChild: q baseExpression.
		mainExpression := RelationExpression new outerJoin: false; relation: #AND; leftChild: q whereClause; rightChild: expression.
		q whereClause: mainExpression.
		newQuery AND: [:each | each perform: aSelector with: q]].
	^newQuery
]

{ #category : #executing }
CompoundQuery >> rowsFromDatabaseWithParameters: anArray [
	^session accessor
		executeCommand: (self sqlWith: anArray)
		returnCursor: true
]

{ #category : #accessing }
CompoundQuery >> shortCircuitEmptyReturn [
	^false
]

{ #category : #accessing }
CompoundQuery >> shortCircuitEmptyReturn: parameters [
	^false
]

{ #category : #accessing }
CompoundQuery >> shouldRefresh [
	^primaryQuery shouldRefresh
]

{ #category : #accessing }
CompoundQuery >> shouldRefresh: aBoolean [
	"We currently ignore sets of this, and use the value from our primary query."
	^self
]

{ #category : #printing }
CompoundQuery >> sqlString [
	"Mostly for debugging"
	^(self sqlWith: #()) sqlString
]

{ #category : #executing }
CompoundQuery >> sqlWith: aDictionary [

	self prepare.
	session platform queryWithUnsupportedOperationsEliminatedFrom: self do: [:newQuery | 
		^newQuery
			prepare;
			sqlWith: aDictionary].
	^CompoundSelectCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session
]

{ #category : #printing }
CompoundQuery >> tablesToPrint [
	^self queries first tablesToPrint
]

{ #category : #accessing }
CompoundQuery >> tracing [
	^primaryQuery tracing
]

{ #category : #'boolean operations' }
CompoundQuery >> unionAll: aQuery [
	aQuery shortCircuitEmptyReturn ifTrue: [^self].
	^self isUnionAll
		ifTrue:
			[queries add: aQuery.
			self]
		ifFalse:
			[(CompoundQuery newUnionAll)
				addQuery: self;
				addQuery: aQuery]
]

{ #category : #accessing }
CompoundQuery >> whereClause [
	| allCriteria |
	allCriteria := queries inject: #() into: [:sum :each | sum, each whereClause].
	^ExpressionGroup new addAll: allCriteria
]
