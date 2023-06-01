"
This is an error that we raise when trying to determine what session to use for an operation, and we don't have enough information to figure it out.

"
Class {
	#name : #CannotFindSession,
	#superclass : #GlorpError,
	#category : #'Glorp-Exceptions'
}

{ #category : #'as yet unclassified' }
CannotFindSession class >> mayResume [
	^true.
]

{ #category : #printing }
CannotFindSession >> defaultMessageText [

	^ 'Cannot find the right session to use - send the #session: message first.'
]
