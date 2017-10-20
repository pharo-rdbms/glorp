converting
targetExpressionFor: eachTarget 
	^(self isConstant: eachTarget)
		ifTrue: [eachTarget]
		ifFalse: [
			eachTarget isGlorpExpression 
			ifTrue: [eachTarget] 
			ifFalse: [(base getTable: eachTarget table) getField: eachTarget]].