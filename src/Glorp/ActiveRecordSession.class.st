"
I am a session for use with the ActiveRecord extension.

I am primarily here to enable soft deletes.
"
Class {
	#name : #ActiveRecordSession,
	#superclass : #GlorpSession,
	#category : #'Glorp-ActiveRecord'
}

{ #category : #'api/transactions' }
ActiveRecordSession >> commitUnitOfWork [

	self convertDeletedObjectsToSoftDeletes.
	^ super commitUnitOfWork
]

{ #category : #'api/transactions' }
ActiveRecordSession >> commitUnitOfWorkAndContinue [

	self convertDeletedObjectsToSoftDeletes.
	^ super commitUnitOfWorkAndContinue
]

{ #category : #'api/transactions' }
ActiveRecordSession >> convertDeletedObjectsToSoftDeletes [

	currentUnitOfWork ifNotNil: [
		| softies now |
		now := DateAndTime current.
		softies := currentUnitOfWork deletedObjects select: [ :ea |
			           ea respondsTo: #deletedAt: ].
		softies do: [ :ea |
			self undelete: ea.
			ea deletedAt: now ] ]
]
