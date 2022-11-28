Class {
	#name : #GlorpFloat4Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpFloat4Test >> defaultDatabaseType [
	^self platform float4.
]

{ #category : #tests }
GlorpFloat4Test >> testFloat4 [

	self helpTestFloat: nil.
	self helpTestValue: 3.14 compareWith: [:read :original |
		read - original <= 0.00001].
]
