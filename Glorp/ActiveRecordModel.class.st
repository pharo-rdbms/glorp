Class {
	#name : #ActiveRecordModel,
	#superclass : #Object,
	#category : #'Glorp-Core'
}

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> all [ 
	^self query execute
]

{ #category : #setup }
ActiveRecordModel class >> descriptorClass [
	"You should return a subclass of ActiveRecordDescriptorSystem here "
	self subclassResponsibility 

]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> find [
	^self query
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> find: aPrimaryKey [
	| pkAttribute cachedSession |
	cachedSession := self session.
	pkAttribute := (cachedSession system descriptorFor: self) primaryKeyMappings first attribute name.
	^(Query readOneOf: self where: [:each | (each perform: pkAttribute) = aPrimaryKey]) execute.
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> findAll [
	^self query
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> first [ 
	^(self query orderBy: [:ea | ea id ]) first 
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> first: aNumber [
	^(self query orderBy: [:ea | ea id ]) first: aNumber
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> last [ 
	^(self query orderBy: [ :ea | ea id descending ]) first 
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> last: aNumber [
	^(self query orderBy: [ :ea | ea id descending ]) limit: aNumber 
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> limit: aNumber [ 
	^self query limit: aNumber 
]

{ #category : #accessing }
ActiveRecordModel class >> newSession [
	^self descriptorClass newSession
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> orderBy: aBlock [
	^self query orderBy: aBlock
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> query [
	"Handle soft deletes"
	^(self instVarNames includes: #deletedAt  ) 
		ifTrue: [ Query read: self where: [:ea | ea deletedAt isNil ] ]
		ifFalse: [ Query read: self ]
]

{ #category : #accessing }
ActiveRecordModel class >> session [ 
	"Delegated down because a base class should have a class variable called session shared among subclasses.  This allows clusters of objects to have different sessions based on base class."
	self subclassResponsibility 
]

{ #category : #accessing }
ActiveRecordModel class >> table [ 
	^(self session system descriptorFor: self) table
]

{ #category : #'typing/selecting keys' }
ActiveRecordModel class >> where: aBlock [
	^self query where: aBlock
]

{ #category : #actions }
ActiveRecordModel >> save [ 
	self session
		requireUnitOfWork;
		register: self.
		
	self session commitUnitOfWorkAndContinue.
	
	^self
]
