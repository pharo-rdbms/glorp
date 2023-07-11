"
An bank branch in the Bank model
"
Class {
	#name : #GlorpBankBranch,
	#superclass : #Object,
	#instVars : [
		'accounts',
		'branchNumber'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #accessing }
GlorpBankBranch >> accounts [

	^ accounts
]

{ #category : #accessing }
GlorpBankBranch >> accounts: anObject [

	accounts := anObject
]

{ #category : #accessing }
GlorpBankBranch >> branchNumber [

	^ branchNumber
]

{ #category : #accessing }
GlorpBankBranch >> branchNumber: aString [

	branchNumber := aString
]

{ #category : #printing }
GlorpBankBranch >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self branchNumber printOn: aStream.
	aStream nextPut: $)
]
