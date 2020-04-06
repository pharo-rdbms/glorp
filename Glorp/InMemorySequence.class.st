"
This is a sequence generator that just generates numbers in memory. Mostly useful for testing, because the numbers aren't guaranteed unique in the database unless we are the only user, and our initial value was appropriately set.

Instance Variables:
	count	<Integer>	The last used identifier.

"
Class {
	#name : #InMemorySequence,
	#superclass : #DatabaseSequence,
	#instVars : [
		'count'
	],
	#category : 'Glorp-Database'
}

{ #category : #'*Glorp' }
InMemorySequence class >> default [

	^self new.
]

{ #category : #public }
InMemorySequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [

	aRow at: aField put: (count := count + 1).
]

{ #category : #'initialize/release' }
InMemorySequence >> initialize [

	super initialize.
	count := 0.
]

{ #category : #sequencing }
InMemorySequence >> postWriteAssignSequenceValueFor: aField in: aRow [
]

{ #category : #sequencing }
InMemorySequence >> postWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
]

{ #category : #sequencing }
InMemorySequence >> preWriteAssignSequenceValueFor: aField in: aRow [

	aRow at: aField put: (count := count + 1).
]
