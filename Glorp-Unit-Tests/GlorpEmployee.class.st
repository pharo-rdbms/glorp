Class {
	#name : #GlorpEmployee,
	#superclass : #GlorpWorkingStiff,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpEmployee class >> glorpTypeResolver [
	^FilteredTypeResolver forRootClass: GlorpEmployee
]
