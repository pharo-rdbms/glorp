Class {
	#name : #GlorpObjectWithNoAccessors,
	#superclass : #Object,
	#instVars : [
		'alue'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpObjectWithNoAccessors >> extremelyPrivateValue: aString [
	alue := aString
]
