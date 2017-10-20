helpers
helpTestValue: anObject compareModelWith: modelBlock compareWith: aBlock 
	self 
		helpTestValueWithSQLWrite: anObject
		compareModelWith: modelBlock
		compareWith: aBlock.
	self 
		helpTestValueWithUnitOfWorkWrite: anObject
		compareModelWith: modelBlock