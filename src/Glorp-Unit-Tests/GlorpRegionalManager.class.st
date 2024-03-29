Class {
	#name : #GlorpRegionalManager,
	#superclass : #GlorpManager,
	#instVars : [
		'region'
	],
	#category : #'Glorp-Unit-Tests-Models - Worker'
}

{ #category : #comparing }
GlorpRegionalManager >> = aRegionalManager [
	^super = aRegionalManager and: [region = aRegionalManager region].
]

{ #category : #accessing }
GlorpRegionalManager >> region [
	^region
]

{ #category : #accessing }
GlorpRegionalManager >> region: anObject [
	region := anObject
]
