Class {
	#name : #GlorpRegionalManager,
	#superclass : #GlorpManager,
	#instVars : [
		'region'
	],
	#category : 'Glorp-Tests-Models'
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
