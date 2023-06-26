Class {
	#name : #GlorpEmployee,
	#superclass : #GlorpWorkingStiff,
	#category : #'Glorp-Unit-Tests-Models - Worker'
}

{ #category : #accessing }
GlorpEmployee class >> glorpTypeResolver [

	^ FilteredTypeResolver forRootClass: GlorpEmployee
]
