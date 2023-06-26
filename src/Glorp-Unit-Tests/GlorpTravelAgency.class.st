"
This represents a travel agency. The interesting persistence feature of these is that they are embedded in the agent table, but also treated as unique objects with their own relationships.

Instance Variables:
	agents	<Collection of: GlorpTravelAgent>	description of agents
	name	<String>	description of name


"
Class {
	#name : #GlorpTravelAgency,
	#superclass : #Object,
	#instVars : [
		'name',
		'agents'
	],
	#category : #'Glorp-Unit-Tests-Models - TravelAgency'
}

{ #category : #comparing }
GlorpTravelAgency >> = aGlorpTravelAgency [

	^ ( aGlorpTravelAgency isKindOf: self class ) and: [ self name = aGlorpTravelAgency name ]
]

{ #category : #accessing }
GlorpTravelAgency >> agents [
	^agents
]

{ #category : #accessing }
GlorpTravelAgency >> agents: anObject [
	agents := anObject
]

{ #category : #comparing }
GlorpTravelAgency >> hash [

	^ self name hash
]

{ #category : #accessing }
GlorpTravelAgency >> name [
	^name
]

{ #category : #accessing }
GlorpTravelAgency >> name: anObject [
	name := anObject
]
