mapping
addPhantomMappingExpressionOn: base 
	| phantomMapping phantomMappingName phantomExpression |
	phantomMapping := self reverseMapping.
	phantomMappingName := 'glorp_internal_' , self attributeName , '_to_' 
				, self descriptor describedClass name.
	phantomExpression := base getMapping: phantomMapping
				named: phantomMappingName.
	phantomExpression bePhantom.
	^phantomExpression