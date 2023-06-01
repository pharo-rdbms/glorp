"
This is the exception we raise if we try to execute a command for which permission has been denied at the Glorp level. e.g. we try to insert while denyWrites is active.

Instance Variables:
	command	<DatabaseCommand>	The command we tried to execute.


"
Class {
	#name : #GlorpIllegalCommand,
	#superclass : #GlorpError,
	#instVars : [
		'command'
	],
	#category : #'Glorp-Exceptions'
}

{ #category : #accessing }
GlorpIllegalCommand >> command [

	^ command
]

{ #category : #accessing }
GlorpIllegalCommand >> command: aDatabaseCommand [

	command := aDatabaseCommand
]

{ #category : #accessing }
GlorpIllegalCommand >> defaultMessageText [

	^ 'Illegal Command'
]

{ #category : #accessing }
GlorpIllegalCommand >> session [

	^ command session
]
