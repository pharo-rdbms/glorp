converting
targetExpressionFor: eachTarget 
	^(self isConstant: eachTarget)
		ifTrue: [eachTarget]
		ifFalse: [
			eachTarget isGlorpExpression 
			ifTrue: [eachTarget] 
			ifFalse: [(self anyJoin base getTable: eachTarget table) getField: eachTarget]].