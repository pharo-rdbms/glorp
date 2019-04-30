"
This is a query that expects all the objects it might return to already be in memory, and in a collection from which it can pick them out by evaluating a block. This is used to implement filtered reads on a mapping. When one of the mappings fires, it reads all the relevant results, and so each instance  using that mapping can get the results out of memory without going to the database again.

Instance Variables:
	collectBlock	<Block>	A one-argument block we evaluate to actually collect up the results. That is, internally we are likely to have a more complex representation in the collection, e.g. an array containing various extra information plus the objects. This gets the objects out of the collection.
	collection	<(GlorpVirtualCollection of: Object)>	The collection on which we filter. Typically a virtual collection, at least for filtered reads, but can also handle a normal collection.
	filter	<Block>	The two-argument block we use to filter. The first argument is the entry from the collection, the second is the parameters to the query that were used.
	readsOneObject	<Boolean>	A duplicate of readsOneObject in AbstractReadyQuery. Do we return a collection, or a single result.


"
Class {
	#name : #FilteringQuery,
	#superclass : #Query,
	#instVars : [
		'collection',
		'filter',
		'collectBlock'
	],
	#category : 'Glorp-Queries'
}

{ #category : #'instance creation' }
FilteringQuery class >> on: aCollection filter: aBlock [
	^(self new)
		collection: aCollection;
 		filter: aBlock
]

{ #category : #accessing }
FilteringQuery >> collectBlock [
	^collectBlock
]

{ #category : #accessing }
FilteringQuery >> collectBlock: aBlock [
	collectBlock:= aBlock
]

{ #category : #accessing }
FilteringQuery >> collection [
	^collection
]

{ #category : #accessing }
FilteringQuery >> collection: aCollection [
	aCollection class == GlorpVirtualCollection ifTrue: [collectionType := aCollection getQuery collectionType].
	collection := aCollection
]

{ #category : #executing }
FilteringQuery >> collectionTypesAgree: aCollection [
	^self collectionType new class == aCollection class
]

{ #category : #executing }
FilteringQuery >> executeWithParameters: parameterArray in: aSession [
	| filtered result |
	session := aSession.
	collection class == GlorpVirtualCollection
		ifTrue:
			[collection setSession: aSession.
			collection parameters: parameterArray.
			collection := collection realObjects].
	filtered := self filterResultsForParameters: parameterArray.
	result := self transformsValues
		ifTrue: [filtered collect: [:each | self valueFor: each]]
		ifFalse: [filtered].
	result := (self collectionTypesAgree: result) ifTrue: [result] ifFalse: [self resultCollectionFor: result readStream].
	^self readsOneObject
		ifTrue: [result detect: [:each | true] ifNone: [nil]]
		ifFalse: [result]
]

{ #category : #accessing }
FilteringQuery >> filter [
	^filter
]

{ #category : #accessing }
FilteringQuery >> filter: aBlock [
	filter := aBlock
]

{ #category : #executing }
FilteringQuery >> filterResultsForParameters: parameterArray [
	| passing seen |
	seen := Dialect newIdentitySet.
	passing := collection
		select:
			[:each | 
			| passes new value |
			passes := filter value: each value: parameterArray.
			value := self valueFor: each.
			passes
				ifTrue:
					[new := (seen includes: value) not.
					new ifTrue: [seen add: value]].
			passes and: [new]].
	^passing
]

{ #category : #accessing }
FilteringQuery >> resultClass [
	collection class == GlorpVirtualCollection ifTrue: [^collection getQuery resultClass].
	^(collection detect: [:each | true] ifNone: [nil]) class
]

{ #category : #testing }
FilteringQuery >> shortCircuitEmptyReturn: parameters [
	^false
]

{ #category : #executing }
FilteringQuery >> transformsValues [
	^collectBlock notNil
]

{ #category : #executing }
FilteringQuery >> valueFor: anObject [
	collectBlock isNil ifTrue: [^anObject].
	^collectBlock value: anObject
]
