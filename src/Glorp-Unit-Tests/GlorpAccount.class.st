Class {
	#name : #GlorpAccount,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'id',
		'name'
	],
	#category : #'Glorp-Unit-Tests-Models - Trade'
}

{ #category : #'instance creation' }
GlorpAccount class >> knownAs: aName [

	^ self new initializeKnownAs: aName
]

{ #category : #accessing }
GlorpAccount >> id [

	^ id
]

{ #category : #initialization }
GlorpAccount >> initializeKnownAs: aName [

	name := aName
]
