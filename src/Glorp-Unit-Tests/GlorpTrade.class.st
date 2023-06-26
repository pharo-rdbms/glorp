Class {
	#name : #GlorpTrade,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'id',
		'account'
	],
	#category : #'Glorp-Unit-Tests-Models - Trade'
}

{ #category : #'instance creation' }
GlorpTrade class >> within: anAccount [

	^ self new initializeWithin: anAccount
]

{ #category : #accessing }
GlorpTrade >> account [

	^ account
]

{ #category : #accessing }
GlorpTrade >> id [

	^ id
]

{ #category : #initialization }
GlorpTrade >> initializeWithin: anAccount [

	account := anAccount
]
