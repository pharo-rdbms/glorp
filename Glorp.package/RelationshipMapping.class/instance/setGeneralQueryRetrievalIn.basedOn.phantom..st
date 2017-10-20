mapping
setGeneralQueryRetrievalIn: newQuery basedOn: base phantom: phantomExpression
	self descriptor keyFields
		do: [:eachField | newQuery retrieve: (phantomExpression getField: eachField)].
	newQuery retrieve: base.