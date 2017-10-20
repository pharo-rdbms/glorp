preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	
	| expression newBase |
	self == anExpression ifTrue: [^aBaseExpression].
	newBase := base rebuildOn: aBaseExpression startingFrom: anExpression
		withOuterScopeBase: ultimateBaseExpression.	
	"For phantom mappings we have to pass through our mapping since they can't compute their own. For the normal case, if we have a mapping, and our base class hasn't changed, then just re-use the same mapping as an optimization."
	expression := (mapping isNil or: [self mustReGetMappingIfRebuildingOn: newBase])
		ifTrue: [newBase get: name]
		ifFalse: [newBase getMapping: self mapping named: name].
	outerJoin ifTrue: [expression asOuterJoin].
	expression phantom: self phantom.
	^expression.