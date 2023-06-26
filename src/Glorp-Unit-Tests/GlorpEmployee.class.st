Class {
	#name : #GlorpEmployee,
	#superclass : #GlorpWorkingStiff,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpEmployee class >> glorpTypeResolver [

	^ FilteredTypeResolver forRootClass: GlorpEmployee
]
