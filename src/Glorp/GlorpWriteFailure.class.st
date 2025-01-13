"
This is the error we raise if we encounter an error trying to write some rows. This typically indicates an optimistic lock failure, although it might also happen if we violated a constraint.

Instance Variables:
	command	<DatabaseCommand>	The command we were trying to execute.
	object	<Object>	The object or objects we were trying to write.


"
Class {
	#name : #GlorpWriteFailure,
	#superclass : #GlorpError,
	#instVars : [
		'command',
		'object'
	],
	#category : #'Glorp-Exceptions'
}

{ #category : #accessing }
GlorpWriteFailure class >> mayResume [

	^ true
]

{ #category : #accessing }
GlorpWriteFailure >> command [

	^ command
]

{ #category : #accessing }
GlorpWriteFailure >> command: anObject [

	command := anObject
]

{ #category : #accessing }
GlorpWriteFailure >> defaultMessageText [

	^ 'Database write failed'
]

{ #category : #accessing }
GlorpWriteFailure >> object [

	^ object
]

{ #category : #accessing }
GlorpWriteFailure >> object: anObject [

	object := anObject
]

{ #category : #accessing }
GlorpWriteFailure >> session [

	^ self command session
]
