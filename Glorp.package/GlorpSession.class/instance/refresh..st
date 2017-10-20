api/queries
refresh: anObject
	"Reload anObject from the corresponding row of its table. Return the refreshed instance."

	| exp query realObject descriptor |
	realObject := self realObjectFor: anObject ifNone: [^self].
	descriptor := self descriptorFor: realObject.
	descriptor isNil
		ifTrue: [self error: 'Cannot refresh an object with no descriptor'].
	exp := descriptor
				primaryKeyExpressionFor: realObject
				basedOn: (BaseExpression new  descriptor: (self descriptorFor: realObject class))
				relation: #=.
	query := Query readOneOf: realObject class where: exp.
	query shouldRefresh: true.
	^self execute: query