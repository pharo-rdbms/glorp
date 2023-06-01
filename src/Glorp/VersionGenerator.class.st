"
An abstract superclass for generators that generate version numbers (rather than sequence numbers).

Subclasses must implement the following messages:
	sequencing
		nextValueFor:in:


"
Class {
	#name : #VersionGenerator,
	#superclass : #GlorpDatabaseValueGenerator,
	#category : #'Glorp-Database'
}

{ #category : #sequencing }
VersionGenerator >> nextValueFor: aField in: aRow [

	self subclassResponsibility
]

{ #category : #sequencing }
VersionGenerator >> preWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
	"Overwrite a pre-existing value in the field if necessary"

	aRow at: aField forcePut: (self nextValueFor: aField in: aRow)
]
