This is the superclass of Glorp expression tree nodes. These are used to represent the where clause of a query, or things that describe relationships between objects and/or represent boolean expressions evaluated against them. They are typically created by converting a block into an expression using asGlorpExpression. Then they are used in generating the SQL string to be sent to the database.

Subclasses must implement the following messages:
	accessing
		canHaveBase
	api
		base
		get:withArguments:
	converting
		asJoin
	navigating
		ultimateBaseExpression
	preparing
		asExpressionJoiningSource:toTarget:
		rebuildOn:startingFrom:withOuterScopeBase:
	printing
		printOnlySelfOn:
		printTreeOn:

