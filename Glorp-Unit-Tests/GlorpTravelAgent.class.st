"
This represents a travel agent. Travel agents are very simple, but have their agency embedded in their table, even though we expect the agencies to be unique instances, and to have multiple agents.

Instance Variables:
	agency	<GlorpTravelAgency>	description of agency
	id	<Integer>	description of id
	name	<String>	description of name


"
Class {
	#name : #GlorpTravelAgent,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'agency'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpTravelAgent >> agency [
	^agency
]

{ #category : #accessing }
GlorpTravelAgent >> agency: anObject [
	agency := anObject
]

{ #category : #accessing }
GlorpTravelAgent >> id [
	^id
]

{ #category : #accessing }
GlorpTravelAgent >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpTravelAgent >> name [
	^name
]

{ #category : #accessing }
GlorpTravelAgent >> name: anObject [
	name := anObject
]
