"
This is a sequence that gets its values from a sequence table. It doesn't look like it's fully implemented, or used.

Instance Variables:
	sequenceTableName	<String>	The name of the sequence table to use.


"
Class {
	#name : 'TableBasedSequence',
	#superclass : 'DatabaseSequence',
	#instVars : [
		'sequenceTableName'
	],
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : '*Glorp' }
TableBasedSequence class >> default [

	^self new sequenceTableName: 'SEQUENCE'.
]

{ #category : 'testing' }
TableBasedSequence >> isIdentityColumn [

	^ true
]

{ #category : 'accessing' }
TableBasedSequence >> sequenceTableName [
	"Private - Answer the value of the receiver's ''sequenceTableName'' instance variable."

	^ sequenceTableName
]

{ #category : 'accessing' }
TableBasedSequence >> sequenceTableName: aString [

	sequenceTableName := aString
]
