accessing
setUpBase
	whereClause isGlorpExpression ifTrue: [base := whereClause queryLevelBaseExpression] ifFalse: [base := BaseExpression new].