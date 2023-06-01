"
This is a fixed size queue of objects. It's intended for keeping around a fixed number of references to objects in a weak dictionary. As such its API is rather limited (one method), and it's write-only.

Instance Variables:
	items	<OrderedCollection>	The items in the queue
	maximumSize	<Integer>	How many items we're allowed
"
Class {
	#name : #FixedSizeQueue,
	#superclass : #Object,
	#instVars : [
		'maximumSize',
		'items'
	],
	#category : #'Glorp-Core'
}

{ #category : #'instance creation' }
FixedSizeQueue class >> maximumSize: anInteger [

	^ self basicNew maximumSize: anInteger
]

{ #category : #'instance creation' }
FixedSizeQueue class >> new [

	self error: 'must supply a size'
]

{ #category : #'instance creation' }
FixedSizeQueue class >> new: anInteger [

	^ self maximumSize: anInteger
]

{ #category : #api }
FixedSizeQueue >> add: anObject [

	items add: anObject.
	items size > maximumSize ifTrue: [ items removeFirst ]
]

{ #category : #accessing }
FixedSizeQueue >> maximumSize [

	^ maximumSize
]

{ #category : #accessing }
FixedSizeQueue >> maximumSize: anInteger [

	maximumSize := anInteger.
	items := OrderedCollection new: maximumSize + 1
]

{ #category : #printing }
FixedSizeQueue >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('.
	aStream nextPutAll: items size printString.
	aStream nextPut: $/.
	aStream nextPutAll: maximumSize printString.
	aStream nextPutAll: ')'
]
