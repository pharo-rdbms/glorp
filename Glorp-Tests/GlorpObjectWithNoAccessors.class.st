Class {
	#name : #GlorpObjectWithNoAccessors,
	#superclass : #Object,
	#instVars : [
		'alue'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpObjectWithNoAccessors >> extremelyPrivateValue: aString [
	alue := aString
]
