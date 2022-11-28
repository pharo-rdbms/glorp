"
This represents a command that executes arbitrary SQL and is not a select. For selects use SQLStringSelectCommand.
"
Class {
	#name : #SQLStringCommand,
	#superclass : #DatabaseCommand,
	#instVars : [
		'parameters',
		'maximumBlobSizeToRetrieveDirectly'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
SQLStringCommand class >> for: aString [
	^self new setSQLString: aString.
]

{ #category : #accessing }
SQLStringCommand >> arrayBoundFields [
	"Don't have enough information to do this, I don't think"
	^#()
]

{ #category : #accessing }
SQLStringCommand >> bindingTypes [
	^#()
]

{ #category : #accessing }
SQLStringCommand >> bindings [
	^parameters.
]

{ #category : #'initialize-release' }
SQLStringCommand >> initialize [

	super initialize.
	maximumBlobSizeToRetrieveDirectly := super maximumLobSizeToRetrieveDirectly.
	parameters := #()
]

{ #category : #accessing }
SQLStringCommand >> maximumLobSizeToRetrieveDirectly [
	^maximumBlobSizeToRetrieveDirectly
]

{ #category : #accessing }
SQLStringCommand >> maximumLobSizeToRetrieveDirectly: anInteger [
	maximumBlobSizeToRetrieveDirectly := anInteger
]

{ #category : #accessing }
SQLStringCommand >> parameterTypeSignature [
	^''
]

{ #category : #accessing }
SQLStringCommand >> parameters [
	^parameters.
]

{ #category : #accessing }
SQLStringCommand >> parameters: anArray [
	parameters := anArray
]

{ #category : #executing }
SQLStringCommand >> printSQL [
	" *** This method was defined by Glorp.DatabaseCommand as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #accessing }
SQLStringCommand >> setSQLString: aString [
	sqlString := aString.
]

{ #category : #testing }
SQLStringCommand >> succeeded [
	" *** This method was defined by Glorp.DatabaseCommand as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]
