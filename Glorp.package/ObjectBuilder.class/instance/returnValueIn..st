accessing
returnValueIn: aCursoredStream
	"If we're a to-many relationship, what we retrieve: is the collection containing us, not the individual items"
	| relatedBuilder |
	expression canKnit ifFalse: [^self instance].
	expression mapping isToManyRelationship ifFalse: [^self instance].
	relatedBuilder := aCursoredStream elementBuilderFor: expression base.
	(relatedBuilder isNil or: [relatedBuilder instance isNil]) ifTrue: [^self instance].
	^expression mapping getValueFrom: relatedBuilder instance