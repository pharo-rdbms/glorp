"
This generates version numbers by adding one to the previous value of the designated field.
"
Class {
	#name : #VersionNumberVersionGenerator,
	#superclass : #VersionGenerator,
	#category : 'Glorp-Database'
}

{ #category : #sequencing }
VersionNumberVersionGenerator >> nextValueFor: aField in: aRow [
	| oldValue |
	oldValue := aRow at: aField ifAbsent: [0].
	^(oldValue isNil ifTrue: [0] ifFalse: [oldValue]) + 1
]
