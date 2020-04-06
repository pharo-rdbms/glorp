"
This represents a virtual collection, i.e. one that we haven't really read into memory yet. It responds to a reasonable subset of collection protocol, and will read the elements into memory only when necessary. So, e.g. a select: operation takes a query block, and is equivalent to AND:ing that query block to the main query.

To create a virtual collection, ask the session for one. e.g. session virtualCollectionOf: AClass.

This is an initial version which will read in the objects fairly eagerly. An optimization might be to defer certain types of operations depending on whether the block can be evaluated into SQL or not. e.g.
  collect: [:each | each name]
can be turned into a retrieve: operation. But 
  collect: [:each | each printString]
cannot. We could try to check the block for operations like collect: and detect:, deferring the point at which the objects will be read in.

Handling of ordering is also a little bit funny. The blocks we like for ordering aren't compatible with sortedCollection type blocks. It'd be nice to be more compatible.


"
Class {
	#name : #GlorpVirtualCollection,
	#superclass : #Collection,
	#instVars : [
		'query',
		'session',
		'realObjects',
		'parameters'
	],
	#category : #'Glorp-Queries'
}

{ #category : #'instance creation' }
GlorpVirtualCollection class >> on: aClass in: aSession [
	^self new on: aClass in: aSession
]

{ #category : #private }
GlorpVirtualCollection >> AND: aBlock [
	query AND: aBlock
]

{ #category : #adding }
GlorpVirtualCollection >> add: newObject [
	self readOnlyError
]

{ #category : #enumerating }
GlorpVirtualCollection >> collect: aBlock [
	^self realObjects collect: aBlock
]

{ #category : #copying }
GlorpVirtualCollection >> copy [
	^self shallowCopy postCopy
]

{ #category : #copying }
GlorpVirtualCollection >> copyAndGrowBy: anInteger [
	"For VA compatibility"
	^super glorpShallowCopy
]

{ #category : #copying }
GlorpVirtualCollection >> copyFrom: start to: stop [
	^self realObjects copyFrom: start to: stop
]

{ #category : #enumerating }
GlorpVirtualCollection >> do: aBlock [
	self realObjects do: aBlock
]

{ #category : #accessing }
GlorpVirtualCollection >> first [
	^self realObjects first
]

{ #category : #private }
GlorpVirtualCollection >> getQuery [
	^query
]

{ #category : #testing }
GlorpVirtualCollection >> isEmpty [
	^self realObjects isEmpty
]

{ #category : #testing }
GlorpVirtualCollection >> isInstantiated [
	^realObjects notNil.
]

{ #category : #accessing }
GlorpVirtualCollection >> last [
	^self realObjects last.
]

{ #category : #'initialize-release' }
GlorpVirtualCollection >> on: aClass in: aSession [
	query := aSession queryClass read: aClass.
	session := aSession.
]

{ #category : #accessing }
GlorpVirtualCollection >> orderBy: aBlockOrExpression [
	query orderBy: aBlockOrExpression.
]

{ #category : #accessing }
GlorpVirtualCollection >> parameters: aCollection [
	parameters := aCollection
]

{ #category : #copying }
GlorpVirtualCollection >> postCopy [
	query := query copy.
	realObjects := nil
]

{ #category : #printing }
GlorpVirtualCollection >> printOn: aStream [
	self isInstantiated
		ifTrue: [super printOn: aStream]
		ifFalse:
			[aStream nextPutAll: 'a virtual collection of '.
			query notNil ifTrue: [aStream nextPutAll: query resultClass name]]
]

{ #category : #private }
GlorpVirtualCollection >> readOnlyError [
	self error: 'Virtual collections are read-only'.
]

{ #category : #private }
GlorpVirtualCollection >> realObjects [
	realObjects isNil ifTrue: [	realObjects := query executeWithParameters: parameters in: session].
	^realObjects.
]

{ #category : #enumerating }
GlorpVirtualCollection >> reject: aBlock [
	^self copy AND: [:each | (aBlock value: each) not]
]

{ #category : #removing }
GlorpVirtualCollection >> remove: oldObject ifAbsent: anExceptionBlock [
	self readOnlyError
]

{ #category : #enumerating }
GlorpVirtualCollection >> select: aBlock [
	^self isInstantiated ifTrue: [self realObjects select: aBlock] ifFalse: [self copy AND: aBlock]
]

{ #category : #accessing }
GlorpVirtualCollection >> setQuery: aQuery [
	"Semi-private. Set the internal query"
	query := aQuery
]

{ #category : #accessing }
GlorpVirtualCollection >> setSession: aSession [
	"Semi-private. Set the session"
	session := aSession
]

{ #category : #accessing }
GlorpVirtualCollection >> size [
	^self realObjects size
]
