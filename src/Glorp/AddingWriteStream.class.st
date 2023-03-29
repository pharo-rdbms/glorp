"
Why *can't* you stream onto a set? Or a bag, or a SortedCollection? No good reason that I can see. This implements only a subset of stream behaviour, that which is necessary to let us build up collections where we have to ""append"" elements using #add: rather than #at:put: and explicit grows.

Instance Variables:
	target	<Collection>	The thing we're streaming onto.


"
Class {
	#name : #AddingWriteStream,
	#superclass : #Object,
	#instVars : [
		'target'
	],
	#category : #'Glorp-Core'
}

{ #category : #'instance creation' }
AddingWriteStream class >> on: aCollection [
	^self new target: aCollection.
]

{ #category : #accessing }
AddingWriteStream >> contents [
	^target
]

{ #category : #accessing }
AddingWriteStream >> nextPut: anObject [
	target add: anObject
]

{ #category : #accessing }
AddingWriteStream >> nextPutAll: aCollection [
	target glorpAddAll: aCollection
]

{ #category : #accessing }
AddingWriteStream >> on: aSet [
	target := aSet
]

{ #category : #accessing }
AddingWriteStream >> target [
	^target
]

{ #category : #accessing }
AddingWriteStream >> target: aCollection [
	target := aCollection
]
