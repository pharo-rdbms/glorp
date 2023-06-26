Class {
	#name : #GlorpManager,
	#superclass : #GlorpEmployee,
	#instVars : [
		'branch'
	],
	#category : #'Glorp-Unit-Tests-Models - Worker'
}

{ #category : #comparing }
GlorpManager >> = aManager [
	^super = aManager and: [branch = aManager branch].
]

{ #category : #accessing }
GlorpManager >> branch [
	^branch
]

{ #category : #accessing }
GlorpManager >> branch: anObject [
	branch := anObject
]
