"
This is the error we raise when we encounter an exception inside Glorp's database write code. This is uniform across dialects, so it can be reliably caught. We wrap the underlying exception.

Instance Variables:
	accessor	<DatabaseAccessor>	The accessor we were executing against.
	command	<DatabaseCommand>	The command we were executing
	databaseError	<Exception>	The exception that the system raised.


"
Class {
	#name : #GlorpDatabaseWriteError,
	#superclass : #GlorpError,
	#instVars : [
		'command',
		'databaseError',
		'accessor'
	],
	#category : #'Glorp-Exceptions'
}

{ #category : #accessing }
GlorpDatabaseWriteError >> accessor [

	^ accessor
]

{ #category : #accessing }
GlorpDatabaseWriteError >> accessor: anObject [

	accessor := anObject
]

{ #category : #accessing }
GlorpDatabaseWriteError >> command [

	^ command
]

{ #category : #accessing }
GlorpDatabaseWriteError >> command: aDatabaseCommand [

	command := aDatabaseCommand
]

{ #category : #accessing }
GlorpDatabaseWriteError >> databaseError [

	^ databaseError
]

{ #category : #accessing }
GlorpDatabaseWriteError >> databaseError: aDatabaseErrorObject [

	databaseError := aDatabaseErrorObject
]

{ #category : #accessing }
GlorpDatabaseWriteError >> session [

	^ command session
]
