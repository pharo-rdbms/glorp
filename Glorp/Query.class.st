"
This is an abstract superclass for Glorp queries.

Subclasses must implement the following messages:
	accessing
		readsOneObject
	executing
		executeWithParameters:in:

Instance Variables:
	collectionType	<Class>	What sort of collection should this query return its results in.
	expectedRows	<Integer>	Roughly how many rows should we expect to get back. Doesn't have to be right, but can be used to set buffer sizes appropriately in the database.
	ordering	<(SequenceableCollection of: (GlorpExpression | Block | Symbol))>	If we order the results, what are the ordering criteria. Either an expression, but one whose root ends up evaluating to a field, or a block or symbol that can be converted to same.
	prepared	<Boolean>	Has this query already been prepared (at the Glorp level), this says nothing about prepared statements for the database, which will be separate objects.
	session	<GlorpSession>	What session should this query execute in. Can be nil until we start to prepare the query.

"
Class {
	#name : #Query,
	#superclass : #Object,
	#instVars : [
		'session',
		'prepared',
		'expectedRows',
		'collectionType',
		'ordering',
		'maximumLobSizeToRetrieveDirectly',
		'readsOneObject',
		'grouping'
	],
	#category : 'Glorp-Queries'
}

{ #category : #'instance creation' }
Query class >> count: aClass [
	^self count: aClass where: nil
]

{ #category : #'*Glorp' }
Query class >> count: aClass where: anExpression [
	| query |
	query := self readOneOf: aClass where: anExpression.
	query retrieve: #countStar.
	^query.
]

{ #category : #'instance creation' }
Query class >> new [

	^super new initialize
]

{ #category : #'*Glorp' }
Query class >> read: aClass [
	^self read: aClass where: nil
]

{ #category : #'*Glorp' }
Query class >> read: aClass where: anExpression [
	"Backward-compatibility, since we changed the class name."

	^SimpleQuery read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> readManyOf: aClass [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass
]

{ #category : #'*Glorp' }
Query class >> readManyOf: aClass where: anExpression [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'. 
	^self read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> readOneOf: aClass [
	^SimpleQuery readOneOf: aClass.
]

{ #category : #'*Glorp' }
Query class >> readOneOf: aClass where: anExpression [
	^SimpleQuery readOneOf: aClass where: anExpression.
]

{ #category : #'*Glorp' }
Query class >> returningManyOf: aClass [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass
]

{ #category : #'*Glorp' }
Query class >> returningManyOf: aClass where: anExpression [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> returningOneOf: aClass [
	"Backward-compatibility, since we changed the class name."
	"returningOneOf: is a synonym of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf: instead'.
	^self readOneOf: aClass.
]

{ #category : #'*Glorp' }
Query class >> returningOneOf: aClass where: anExpression [
	"Backward-compatibility, since we changed the class name."
	"returningOneOf: is a synonym of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: anExpression
]

{ #category : #accessing }
Query >> collectionType [
	"Note that queries default the collection type to array, while mappings default to OrderedCollection. I think it makes sense"
	collectionType isNil ifTrue: [collectionType := Array].
	^collectionType.
]

{ #category : #accessing }
Query >> collectionType: aClass [
	collectionType := aClass
]

{ #category : #copying }
Query >> copy [
	^self shallowCopy postCopy
]

{ #category : #copying }
Query >> copyAttributesTo: newQuery [
	"We're creating a new query similar to ourselves, ut not a direct copy. Copy over the relevant attributes. Note that we don't copy over the ordering, because that's less universally appropriate. Caller beware."

	newQuery expectedRows: self expectedRows.
	newQuery collectionType: self collectionType.
	newQuery readsOneObject: self readsOneObject.
	newQuery maximumLobSizeToRetrieveDirectly: self maximumLobSizeToRetrieveDirectly
]

{ #category : #executing }
Query >> executeIn: aSession [

	^self executeWithParameters:#() in: aSession
]

{ #category : #executing }
Query >> executeWithParameters: parameterArray in: aSession [ 
	self subclassResponsibility
]

{ #category : #accessing }
Query >> expectedRows [
	"How many rows do we think it's likely this query will bring back. Used for tweaking things like block factor"
	^expectedRows isNil
		ifTrue: [expectedRows := self readsOneObject ifTrue: [1] ifFalse: [100]]
		ifFalse: [expectedRows]
]

{ #category : #accessing }
Query >> expectedRows: anInteger [
	"How many rows do we think it's likely this query will bring back. Used for tweaking things like block factor"
	expectedRows := anInteger
]

{ #category : #ordering }
Query >> expressionBlockFor: anOrderingCriteria [
	"Allow us to use symbols interchangeably with simple blocks for ordering, so 
	#firstName is equivalent to [:each | each firstName]. Also, allow chains of symbols, so #(owner firstName)"

	anOrderingCriteria isGlorpExpression ifTrue: [^anOrderingCriteria].
	anOrderingCriteria glorpIsBlock ifTrue: [^anOrderingCriteria].

	anOrderingCriteria isSymbol 
		ifTrue: [^[:each | each perform: anOrderingCriteria]].
	
	"otherwise, we assume it's a collection of symbols, the only other valid case"
	anOrderingCriteria do: [:each | each isSymbol ifFalse: [self error: 'invalid ordering criteria']].
	^[:each | anOrderingCriteria inject: each into: [:sum :eachExpression |
		sum perform: eachExpression]]
]

{ #category : #ordering }
Query >> groupBy [
	"Preserve prior behaviour:  return nil or the first groupBy, which previously was the only groupBy and will likely be the only groupBy in all cases where calling this makes sense.  The sole known appropriate use for this method is to allow a prior version of Glorp to be loaded from Store.  However it can be used as a shortcut when it is known that grouping only has one item (or the first is intentionally sought).  As with #setOrdering:, we make the assumption that noone will ever #setGrouping: to an empty collection or a collection that is later emptied (all checks of ordering assume nil is the only empty condition that need be considered)."

	^grouping isNil ifFalse: [grouping first]
]

{ #category : #ordering }
Query >> groupBy: aBlock [

	grouping isNil
		ifTrue: [grouping := Array with: aBlock]
		ifFalse: [grouping := grouping , (Array with: aBlock)].
]

{ #category : #ordering }
Query >> grouping [
	^grouping
]

{ #category : #testing }
Query >> hasGrouping [
	^self grouping notNil
]

{ #category : #testing }
Query >> hasOrdering [

	^self ordering notNil
]

{ #category : #'initialize-release' }
Query >> initialize [

	prepared := false.
	maximumLobSizeToRetrieveDirectly := 32768
]

{ #category : #accessing }
Query >> maximumLobSizeToRetrieveDirectly [
	^maximumLobSizeToRetrieveDirectly
]

{ #category : #accessing }
Query >> maximumLobSizeToRetrieveDirectly: anInteger [
	maximumLobSizeToRetrieveDirectly := anInteger
]

{ #category : #ordering }
Query >> orderBy: aBlock [
	ordering isNil 
		ifTrue: [ordering := Array with: aBlock]
		ifFalse: [ordering := ordering , (Array with: aBlock)]
]

{ #category : #ordering }
Query >> ordering [
	^ordering
]

{ #category : #accessing }
Query >> platform [
	^session system platform
]

{ #category : #copying }
Query >> postCopy [

	prepared := false
]

{ #category : #'sql generation' }
Query >> printCompoundSelectAliasesOn: aStream [
	^self
]

{ #category : #'sql generation' }
Query >> printGroupingOn: aStream [
	grouping isNil
		ifTrue: [ ^ self ].
	aStream nextPutAll: ' GROUP BY '.

	GlorpHelper
		do: [:each |
			each
				rewriteFunctionArguments;
				printSQLOn: aStream withParameters: nil]
		for: grouping
		separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #printing }
Query >> printOn: aStream [
	"I hate the printing with namespaces in vw"
      | title |
        title := self class name.
        aStream nextPutAll:
                ((title at: 1) isVowel ifTrue: ['an '] ifFalse: ['a ']).
        aStream nextPutAll: title
]

{ #category : #'sql generation' }
Query >> printOrderingOn: aStream [
	"Before printing, send each expression >>rewriteFunctionArguments.
	It has no effect for most expressions and most functions, but is
	needed with some platforms (see Substring)."

	ordering isNil ifTrue: [^self].
	aStream nextPutAll: ' ORDER BY '.
	GlorpHelper
		do: [:each |
			each
				rewriteFunctionArguments;
				printSQLOn: aStream withParameters: nil]
		for: ordering
		separatedBy: [aStream nextPutAll: ', ']
]

{ #category : #accessing }
Query >> readsOneObject [
	readsOneObject isNil ifTrue: [^false].
	^readsOneObject.
]

{ #category : #accessing }
Query >> readsOneObject: aBoolean [ 
	readsOneObject := aBoolean
]

{ #category : #executing }
Query >> resultCollectionFor: aCursoredStream [
	| results finalAnswer |
	collectionType isNil ifTrue: [^aCursoredStream upToEnd].
	collectionType == aCursoredStream class ifTrue: [^aCursoredStream].
	results := (aCursoredStream newCollectionOfSize: self expectedRows for: collectionType) writeStream.
	results nextPutAll: aCursoredStream upToEnd.
	finalAnswer := results contents.
	session register: finalAnswer.
	^finalAnswer
]

{ #category : #'specifying retrievals' }
Query >> retrieveDictionaryWithKey: keyExpression value: valueExpression [

	self collectionType: (GlorpDictionaryDescription new keyExpression: keyExpression; valueExpression: valueExpression)
]

{ #category : #'specifying retrievals' }
Query >> returnsDictionary [

	^collectionType class == GlorpDictionaryDescription
]

{ #category : #'sql generation' }
Query >> rewriteExcept [
	"Rewrite any EXCEPT operation we have into a NOT EXISTS tests. Only a CompoundQuery would have such an operation"
]

{ #category : #'sql generation' }
Query >> rewriteIntersect [
	"Rewrite any INTERSECT operation we have into an EXISTS tests. Only a CompoundQuery would have such an operation"
]

{ #category : #accessing }
Query >> session [
	^session
]

{ #category : #accessing }
Query >> session: aSession [ 
	session := aSession
]

{ #category : #ordering }
Query >> setGrouping: aCollection [
	grouping := aCollection.
]

{ #category : #ordering }
Query >> setOrdering: aCollection [
	ordering := aCollection
]

{ #category : #testing }
Query >> shortCircuitEmptyReturn: parameters [
	^false
]
