Class {
	#name : #GlorpTravelFolder,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'files',
		'unordered'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #'instance creation' }
GlorpTravelFolder class >> new [

	^super new initialize
]

{ #category : #accessing }
GlorpTravelFolder >> files [

	^files
]

{ #category : #accessing }
GlorpTravelFolder >> files: anObject [

	files := anObject
]

{ #category : #accessing }
GlorpTravelFolder >> id [

	^id
]

{ #category : #accessing }
GlorpTravelFolder >> id: anObject [

	id := anObject
]

{ #category : #'initialize-release' }
GlorpTravelFolder >> initialize [
	files := OrderedCollection new.
	unordered := OrderedCollection new.
]

{ #category : #accessing }
GlorpTravelFolder >> name [

	^name
]

{ #category : #accessing }
GlorpTravelFolder >> name: anObject [

	name := anObject
]

{ #category : #accessing }
GlorpTravelFolder >> unordered [

	^unordered
]

{ #category : #accessing }
GlorpTravelFolder >> unordered: anObject [

	unordered := anObject
]
