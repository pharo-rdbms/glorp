mapping
setGeneralQueryRetrievalIn: newQuery basedOn: base phantom: phantomExpression
	| keyExpression valueExpression collType keyExpressionBase valueExpressionBase |
	self descriptor primaryKeyMappings
		do:
			[:eachMapping | newQuery retrieve: (phantomExpression get: eachMapping attributeName)].
	keyExpressionBase := self
		chooseBaseForMapping: keyMapping
		from: base
		and: phantomExpression.
	keyExpression := self keyExpression asGlorpExpressionOn: keyExpressionBase.
	valueExpressionBase := self
		chooseBaseForMapping: valueMapping
		from: base
		and: phantomExpression.
	valueExpression := self valueExpression
		asGlorpExpressionOn: valueExpressionBase.
	collType := (GlorpDictionaryDescription new)
		keyExpression: keyExpression;
		valueExpression: valueExpression.
	newQuery collectionType: collType.
	newQuery retrieve: base