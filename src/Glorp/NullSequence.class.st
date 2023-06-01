"
This is a sequence that doesn't do anything. It's really just a placeholder.
"
Class {
	#name : #NullSequence,
	#superclass : #DatabaseSequence,
	#classVars : [
		'Singleton'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
NullSequence class >> default [

	^self new.
]

{ #category : #'*Glorp' }
NullSequence class >> new [

	Singleton isNil ifTrue: [Singleton := self basicNew].
	^Singleton.
]

{ #category : #sequencing }
NullSequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: aSession [
]

{ #category : #sequencing }
NullSequence >> postWriteAssignSequenceValueFor: aField in: aRow [
]

{ #category : #sequencing }
NullSequence >> postWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
]

{ #category : #sequencing }
NullSequence >> preWriteAssignSequenceValueFor: aField in: aRow [
]
