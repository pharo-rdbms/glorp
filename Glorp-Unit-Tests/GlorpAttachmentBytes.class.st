Class {
	#name : #GlorpAttachmentBytes,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpAttachmentBytes class >> glorpSetupClassModel: model forSystem: system [ 
	model newAttributeNamed: #content
]

{ #category : #'as yet unclassified' }
GlorpAttachmentBytes class >> glorpSetupDescriptor: aDesc forSystem: system [ 
	| t |
	t := system tableNamed: 'attachmentbytes'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #content
		to: (t fieldNamed: 'content')
]

{ #category : #accessing }
GlorpAttachmentBytes >> content [
	^content
]

{ #category : #accessing }
GlorpAttachmentBytes >> content: anObject [
	content := anObject
]
