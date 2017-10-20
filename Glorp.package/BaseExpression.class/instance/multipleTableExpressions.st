accessing
multipleTableExpressions
	^self descriptor multipleTableJoin 
		collect: [:each | each asExpressionJoiningSource: self toTarget: self]