"
This is the exception we raise if we encounter a database error trying to commit a transaction.

"
Class {
	#name : 'GlorpTransactionFailure',
	#superclass : 'GlorpError',
	#category : 'Glorp-Exceptions',
	#package : 'Glorp',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
GlorpTransactionFailure >> defaultMessageText [

	^ 'Optimistic Lock Conflict'
]
