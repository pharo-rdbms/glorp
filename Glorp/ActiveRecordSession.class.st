Class {
	#name : #ActiveRecordSession,
	#superclass : #GlorpSession,
	#category : #'Glorp-ActiveRecord'
}

{ #category : #'api/queries' }
ActiveRecordSession >> count: aClass [
	^self execute: (ActiveRecordQuery count: aClass)
]

{ #category : #'api/queries' }
ActiveRecordSession >> count: aClass where: anExpression [
	^self execute: (ActiveRecordQuery count: aClass where: anExpression)
]

{ #category : #'api/queries' }
ActiveRecordSession >> read: aClass [
	"Return an array of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (ActiveRecordQuery read: aClass)
]

{ #category : #'api/queries' }
ActiveRecordSession >> read: aClass limit: anInteger [
	"Return an array of not more than anInteger of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (ActiveRecordQuery read: aClass limit: anInteger)
]

{ #category : #'api/queries' }
ActiveRecordSession >> read: aClass orderBy: aCriteria [
	"aCriteria can be a block, such as [:each | each id], or a symbol (that Glorp can translate into such a block), such as #id."

	| query |
	query := ActiveRecordQuery read: aClass.
	query orderBy: aCriteria.
	^self execute: query
]

{ #category : #'api/queries' }
ActiveRecordSession >> read: aClass where: aBlock [
	"aBlock should return a boolean, for example, [:each | each lastname = 'Doe']."

	^self execute: (ActiveRecordQuery read: aClass where: aBlock)
]

{ #category : #'api/queries' }
ActiveRecordSession >> read: aClass where: aBlock limit: anInteger [
	"Return an array of up to anInteger instances of aClass for which aBlock returns true, each from a row from its table."

	^self execute:
		(ActiveRecordQuery
			read: aClass
			where: aBlock
			limit: anInteger)
]

{ #category : #'api/queries' }
ActiveRecordSession >> readOneOf: aClass [
	"Return a single instance of aClass from a row of its table."

	^self execute: (ActiveRecordQuery readOneOf: aClass)
]

{ #category : #'api/queries' }
ActiveRecordSession >> readOneOf: aClass where: aBlock [
	"aBlock should return a boolean, for example, [:each | each title='Report']."

	^self execute: (ActiveRecordQuery readOneOf: aClass where: aBlock)
]
