Extension { #name : #AbstractReadQuery }

{ #category : #'*Glorp' }
AbstractReadQuery classSide >> read: aClass [
	^self read: aClass where: nil
]

{ #category : #'*Glorp' }
AbstractReadQuery classSide >> read: aClass where: anExpression [
	^self read: aClass where: anExpression limit: nil
]

{ #category : #'*Glorp' }
AbstractReadQuery classSide >> readOneOf: aClass [
	^self readOneOf: aClass where: nil.
]

{ #category : #'*Glorp' }
AbstractReadQuery classSide >> readOneOf: aClass where: anExpression [
	^self newQuery
		initResultClass: aClass
		whereClause: anExpression
		singleObject: true.
]
