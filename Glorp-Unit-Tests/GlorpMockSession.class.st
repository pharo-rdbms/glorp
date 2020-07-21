Class {
	#name : #GlorpMockSession,
	#superclass : #GlorpSession,
	#instVars : [
		'rows'
	],
	#category : #'Glorp-Unit-Tests-Database'
}

{ #category : #'instance creation' }
GlorpMockSession class >> new [

	^super new initialize.
]

{ #category : #accessing }
GlorpMockSession >> accessor [
	^GlorpMockAccessor new.
]

{ #category : #initialize }
GlorpMockSession >> initialize [

	super initialize.
	rows := OrderedCollection new.
]

{ #category : #accessing }
GlorpMockSession >> rows [

	^rows.
]

{ #category : #testing }
GlorpMockSession >> useBinding [
	^true.
]

{ #category : #'read/write' }
GlorpMockSession >> writeHomogeneousRows: aCollection [
	aCollection do: [:each | self writeRow: each].
	^true.
]

{ #category : #'read/write' }
GlorpMockSession >> writeRow: aRow [
	aRow shouldBeWritten ifFalse: [^true].
	aRow preWriteAssignSequencesUsing: self.
	rows add: aRow.
	aRow postWriteAssignSequencesUsing: self accessor.
	^true.
]
