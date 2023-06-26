"
An encyclopedia bio entry in the Encyclopedia model
"
Class {
	#name : #GlorpEncyclopediaBioEntry,
	#superclass : #Object,
	#instVars : [
		'owner',
		'title',
		'text'
	],
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> text [

	^ text
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> text: anObject [

	text := anObject
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> title [

	^ title
]

{ #category : #accessing }
GlorpEncyclopediaBioEntry >> title: anObject [

	title := anObject
]
