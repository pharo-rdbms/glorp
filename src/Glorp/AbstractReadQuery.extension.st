Extension { #name : 'AbstractReadQuery' }

{ #category : '*Glorp' }
AbstractReadQuery class >> read: aClass [
	^self read: aClass where: nil
]

{ #category : '*Glorp' }
AbstractReadQuery class >> read: aClass where: anExpression [
	^self read: aClass where: anExpression limit: nil
]

{ #category : '*Glorp' }
AbstractReadQuery class >> readOneOf: aClass [
	^self readOneOf: aClass where: nil.
]

{ #category : '*Glorp' }
AbstractReadQuery class >> readOneOf: aClass where: anExpression [
	^self newQuery
		initResultClass: aClass
		whereClause: anExpression
		singleObject: true.
]
