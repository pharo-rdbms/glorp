"
This is an exception we raise when we detect two different objects with the same primary key in our cache.

"
Class {
	#name : #DuplicatePrimaryKeyException,
	#superclass : #GlorpError,
	#instVars : [
		'existingObject',
		'newObject'
	],
	#category : 'Glorp-Exceptions'
}

{ #category : #'as yet unclassified' }
DuplicatePrimaryKeyException class >> new: newObject existing: existingObject [
	^self new
		newObject: newObject;
		existingObject: existingObject;
		yourself.
]

{ #category : #accessing }
DuplicatePrimaryKeyException >> defaultMessageText [
	^'Duplicate objects with same primary key'.
]

{ #category : #accessing }
DuplicatePrimaryKeyException >> existingObject [
	^existingObject
]

{ #category : #accessing }
DuplicatePrimaryKeyException >> existingObject: anObject [
	existingObject := anObject
]

{ #category : #accessing }
DuplicatePrimaryKeyException >> newObject [
	^newObject
]

{ #category : #accessing }
DuplicatePrimaryKeyException >> newObject: anObject [
	newObject := anObject
]
