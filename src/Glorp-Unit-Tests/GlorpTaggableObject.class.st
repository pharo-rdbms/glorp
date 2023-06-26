Class {
	#name : #GlorpTaggableObject,
	#superclass : #Object,
	#instVars : [
		'tags'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #initialization }
GlorpTaggableObject >> initialize [

	super initialize.
	tags := OrderedCollection new
]

{ #category : #accessing }
GlorpTaggableObject >> tags [
	^ tags
]

{ #category : #accessing }
GlorpTaggableObject >> tags: someTags [
	tags := someTags
]
