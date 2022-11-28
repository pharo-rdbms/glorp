Class {
	#name : #GlorpCustomer,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'transactions',
		'accounts',
		'accountsSortedById',
		'accountsSortedByIdDescending',
		'eventsReceived',
		'seenPostFetch',
		'seenPreWrite',
		'seenPostWrite',
		'seenExpiry'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #examples }
GlorpCustomer class >> example1 [

	^self new
		name: 'Fred Flintstone';
		addTransaction: GlorpBankTransaction example1;
		addTransaction: GlorpBankTransaction example2.
]

{ #category : #examples }
GlorpCustomer class >> example2 [

	^self new
          id: 123;
		name: 'Fred Flintstone';
		addTransaction: GlorpBankTransaction example1;
		addTransaction: GlorpBankTransaction example2.
]

{ #category : #examples }
GlorpCustomer class >> exampleD1 [

	^self new
		name: 'Fred Flintstone'
]

{ #category : #examples }
GlorpCustomer class >> exampleD2 [

	^self new
		name: 'Wilma Flintstone'
]

{ #category : #examples }
GlorpCustomer class >> exampleD3 [

	^self new
		name: 'Pebbles Flintstone'
]

{ #category : #'as yet unclassified' }
GlorpCustomer class >> new [

	^super new initialize.
]

{ #category : #accessing }
GlorpCustomer >> accounts [

	^accounts.
]

{ #category : #accessing }
GlorpCustomer >> accounts: aCollection [

	accounts := aCollection.
]

{ #category : #'As yet unclassified' }
GlorpCustomer >> accountsSortedById [
	^accountsSortedById.
]

{ #category : #'As yet unclassified' }
GlorpCustomer >> accountsSortedByIdDescending [
	^accountsSortedByIdDescending.
]

{ #category : #accessing }
GlorpCustomer >> addAccount: aBankAccount [

	accounts add: aBankAccount.
	aBankAccount basicAddHolder: self.
]

{ #category : #accessing }
GlorpCustomer >> addTransaction: aTransaction [

	transactions add: aTransaction.
	aTransaction owner: self.
]

{ #category : #'glorp/events' }
GlorpCustomer >> glorpNoticeOfExpiryIn: aSession [
	seenExpiry := true.
]

{ #category : #'glorp/events' }
GlorpCustomer >> glorpPostFetch: aSession [
	seenPostFetch := true
]

{ #category : #'glorp/events' }
GlorpCustomer >> glorpPostWrite: aSession [
	seenPostWrite := true
]

{ #category : #'glorp/events' }
GlorpCustomer >> glorpPreWrite: aSession [
	seenPreWrite := true
]

{ #category : #accessing }
GlorpCustomer >> id [
	"Private - Answer the value of the receiver's ''id'' instance variable."

	^id
]

{ #category : #accessing }
GlorpCustomer >> id: anObject [
	"Private - Set the value of the receiver's ''id'' instance variable to the argument, anObject."

	id := anObject
]

{ #category : #'initialize/release' }
GlorpCustomer >> initialize [

	transactions := OrderedCollection new.
	accounts := OrderedCollection new.
	seenExpiry := false.
	seenPostFetch := false.
	seenPreWrite:= false.
	seenPostWrite := false.
]

{ #category : #accessing }
GlorpCustomer >> name [
	"Private - Answer the value of the receiver's ''name'' instance variable."

	^name
]

{ #category : #accessing }
GlorpCustomer >> name: anObject [
	"Private - Set the value of the receiver's ''name'' instance variable to the argument, anObject."

	name := anObject
]

{ #category : #printing }
GlorpCustomer >> printOn: aStream [ 
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: id;
		nextPut: $,;
		nextPutAll: (name ifNil: ['']);
		nextPutAll: ')'
]

{ #category : #accessing }
GlorpCustomer >> removeAccount: aBankAccount [

	accounts remove: aBankAccount.
	aBankAccount basicRemoveHolder: self.
]

{ #category : #'glorp/events' }
GlorpCustomer >> seenExpiry [
	^seenExpiry
]

{ #category : #accessing }
GlorpCustomer >> seenPostFetch [
	^seenPostFetch
]

{ #category : #accessing }
GlorpCustomer >> seenPostWrite [
	^seenPostWrite
]

{ #category : #accessing }
GlorpCustomer >> seenPreWrite [
	^seenPreWrite
]

{ #category : #accessing }
GlorpCustomer >> transactions [
	"Private - Answer the value of the receiver's ''transactions'' instance variable."

	^transactions
]

{ #category : #accessing }
GlorpCustomer >> transactions: anObject [
	"Private - Set the value of the receiver's ''transactions'' instance variable to the argument, anObject."

	transactions := anObject
]
