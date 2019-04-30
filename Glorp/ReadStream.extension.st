Extension { #name : #ReadStream }

{ #category : #'*Glorp' }
ReadStream >> actuallyAtEnd [
	"For working around a VA cursor problem"
	^self atEnd
]

{ #category : #'*Glorp' }
ReadStream >> collect: aBlock [
	| newStream |
	newStream := collection species new writeStream.
	[self atEnd] whileFalse: [newStream nextPut: (aBlock value: self next)].
	^newStream contents

"Use #writeStream, not WriteStream on: collection species, for portability;  VA cannot stream over all AdditiveSequenceableCollections."
]

{ #category : #'*Glorp' }
ReadStream >> collectionTypeFor: aClass [
	^aClass.
]

{ #category : #'*Glorp' }
ReadStream >> detect: aBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	^self detect: aBlock ifNone: [self error: 'not found']
]

{ #category : #'*Glorp' }
ReadStream >> detect: aBlock ifNone: exceptionBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	self do: [:each | (aBlock value: each) ifTrue: [^each]].
	^exceptionBlock value
]

{ #category : #'*Glorp' }
ReadStream >> includes: anObject [
	self do: [:each | each = anObject ifTrue: [^true]].
	^false.
]

{ #category : #'*Glorp' }
ReadStream >> newCollectionOfSize: aSize for: aCollectionType [

	^aCollectionType isBehavior ifTrue: [aCollectionType new: aSize] ifFalse: [aCollectionType copyEmpty: aSize].
]

{ #category : #'*Glorp' }
ReadStream >> select: aBlock [
	| newStream |
	newStream := collection species new writeStream.
	[self atEnd] whileFalse: [
		| current |
		current := self next.
		(aBlock value: current) ifTrue: [newStream nextPut: current]].
	^newStream contents

"Use #writeStream, not WriteStream on: collection species, for portability;  VA cannot stream over all AdditiveSequenceableCollections."
]

{ #category : #'*Glorp' }
ReadStream >> statement: aGlorpPreparedStatement [
	"This is the statement used to create us. If it's coming back to a simple read stream, then we must have already used all its data, and can thus reuse it"
	aGlorpPreparedStatement busy: false.
]
