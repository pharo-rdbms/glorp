"
I am a subclass of SimpleQuery and act the same except that I prepend the condition deleted_at is null to all my queries if the table being referenced has a field deleted_at.


"
Class {
	#name : 'ActiveRecordQuery',
	#superclass : 'SimpleQuery',
	#category : 'Glorp-ActiveRecord',
	#package : 'Glorp',
	#tag : 'ActiveRecord'
}

{ #category : 'accessing' }
ActiveRecordQuery >> session: aSession [

	super session: aSession.
	aSession ifNotNil: [
		((resultClass isBehavior and: [
			  resultClass canUnderstand: #deletedAt ]) and: [
			 | table |
			 table := aSession system tableForClass: self resultClass.
			 (table fieldNamed: #deleted_at ifAbsent: [  ] caseSensitive: false)
				 notNil ]) ifTrue: [ self AND: [ :ea | ea deletedAt isNIL ] ] ]
]
