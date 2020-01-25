Extension { #name : #Query }

{ #category : #'*Glorp' }
Query class >> count: aClass where: anExpression [
	| query |
	query := self readOneOf: aClass where: anExpression.
	query retrieve: #countStar.
	^query.
]

{ #category : #'*Glorp' }
Query class >> delegateClass [
	^delegate ifNil: [ delegate := SimpleQuery ]
]

{ #category : #'*Glorp' }
Query class >> delegateTo: aClass [ 
	"Making Query pluggable.  I think we could replace the default query class with ActiveRecordQuery with no ill effects even without using AR but am not sure so this formalizes the current practice of using Query for factory for SimpleQuery objects.  The inintialize methods in DescriptorSystem and ActiveRecordDescriptorSystem call this and set up their preferred query class.  The assmumption is that you are not mixing AR with non AR in the same image.  I would have preferred delegating query creation to the descriptor system but there are class size instantitations that don't have any context floating around"
	delegate := aClass
]

{ #category : #'*Glorp' }
Query class >> read: aClass [
	^self read: aClass where: nil
]

{ #category : #'*Glorp' }
Query class >> read: aClass where: anExpression [
	"Backward-compatibility, since we changed the class name."

	^self delegateClass read: aClass where: anExpression
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
	^self delegateClass readOneOf: aClass.
]

{ #category : #'*Glorp' }
Query class >> readOneOf: aClass where: anExpression [
	^self delegateClass readOneOf: aClass where: anExpression.
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
