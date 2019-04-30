"
This represents a command with no additional syntax, basically just a stream. Useful for testing the generation of chunks of SQL.
"
Class {
	#name : #GlorpNullCommand,
	#superclass : #DatabaseCommand,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #'instance creation' }
GlorpNullCommand class >> useBinding: aBoolean session: aSession [
	^(self new)
		useBinding: aBoolean;
		session: aSession;
		yourself.
]

{ #category : #accessing }
GlorpNullCommand >> sqlString [
	^stream contents.
]

{ #category : #testing }
GlorpNullCommand >> succeeded [
	^true.
]
