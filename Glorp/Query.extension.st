Extension { #name : #Query }

{ #category : #'*Glorp' }
Query class >> count: aClass where: anExpression [
	| query |
	query := self readOneOf: aClass where: anExpression.
	query retrieve: #countStar.
	^query.
]

{ #category : #'*Glorp' }
Query class >> read: aClass [
	^self read: aClass where: nil
]

{ #category : #'*Glorp' }
Query class >> read: aClass where: anExpression [
	"Backward-compatibility, since we changed the class name."

	^SimpleQuery read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> readManyOf: aClass [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass
]

{ #category : #'*Glorp' }
Query class >> readManyOf: aClass where: anExpression [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'. 
	^self read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> readOneOf: aClass [
	^SimpleQuery readOneOf: aClass.
]

{ #category : #'*Glorp' }
Query class >> readOneOf: aClass where: anExpression [
	^SimpleQuery readOneOf: aClass where: anExpression.
]

{ #category : #'*Glorp' }
Query class >> returningManyOf: aClass [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass
]

{ #category : #'*Glorp' }
Query class >> returningManyOf: aClass where: anExpression [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: anExpression
]

{ #category : #'*Glorp' }
Query class >> returningOneOf: aClass [
	"Backward-compatibility, since we changed the class name."
	"returningOneOf: is a synonym of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf: instead'.
	^self readOneOf: aClass.
]

{ #category : #'*Glorp' }
Query class >> returningOneOf: aClass where: anExpression [
	"Backward-compatibility, since we changed the class name."
	"returningOneOf: is a synonym of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: anExpression
]
