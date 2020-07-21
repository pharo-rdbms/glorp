Class {
	#name : #GlorpBankAccountNumber,
	#superclass : #Object,
	#instVars : [
		'bankCode',
		'branchNumber',
		'accountNumber'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #examples }
GlorpBankAccountNumber class >> example12345 [

	^self new
		accountNumber: 12345;
		bankCode: 4;
		branchNumber: 777.
]

{ #category : #accessing }
GlorpBankAccountNumber >> accountNumber [
	^accountNumber
]

{ #category : #accessing }
GlorpBankAccountNumber >> accountNumber: anObject [
	accountNumber := anObject
]

{ #category : #accessing }
GlorpBankAccountNumber >> bankCode [
	^bankCode
]

{ #category : #accessing }
GlorpBankAccountNumber >> bankCode: anObject [
	bankCode := anObject
]

{ #category : #accessing }
GlorpBankAccountNumber >> branchNumber [
	^branchNumber
]

{ #category : #accessing }
GlorpBankAccountNumber >> branchNumber: anObject [
	branchNumber := anObject
]
