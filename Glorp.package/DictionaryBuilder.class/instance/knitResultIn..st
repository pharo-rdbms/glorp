building objects
knitResultIn: aCursoredStream
	"Connect up our built object with any other objects that reference it. Used if we retrieve more than one thing in the same query"
	| relatedBuilder |
	instance key: keyBuilder instance.
	instance value: valueBuilder instance.

	"Code from ObjectBuilder>>knitResultIn:"
	expression canKnit ifFalse: [^self].
	relatedBuilder := aCursoredStream objectBuilderFor: expression base.
	(relatedBuilder isNil or: [relatedBuilder instance isNil]) 
		ifFalse: 
			[expression mapping knitFromBuilder: relatedBuilder toBuilder: self]