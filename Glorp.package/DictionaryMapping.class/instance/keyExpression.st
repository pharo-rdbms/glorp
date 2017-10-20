mapping
keyExpression
	"Return the expression to use for our key. The key can be built using data from either the target object, or from the link table, so build the expression on one or the other, as appropriate"
	 | base intermediate |
	base := BaseExpression new.
	intermediate := (self descriptor tables includes: keyMapping mappedFields first table)
		ifTrue: [base] 
		ifFalse: [base getTable: keyMapping mappedFields first table].
	^intermediate getMapping: keyMapping named: #key