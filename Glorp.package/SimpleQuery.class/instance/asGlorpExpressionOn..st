converting
asGlorpExpressionOn: anExpression
	"If we're being converted into an expression, that means we're a subselect inside an expression block. We don't actually have any relationship to anExpression, so create our own base and make a pseudo-mapping with no join to describe the relationship. Don't even give it a string-name, just use ourselves as the key"
	
	| expression localBase phantomMapping phantomExpression |
	phantomMapping := OneToOneMapping new
		referenceClass: self resultClass;
		attributeName: #temporaryAttributeFromSubselect;
		join: Join new;
		descriptor: (anExpression system descriptorFor: self resultClass).
	phantomExpression := anExpression getMapping: phantomMapping named: self.
	expression := GeneralSubSelectExpression 
		basedOn: phantomExpression.
	expression query: self.
	localBase := SubSelectBaseExpression on: phantomExpression.
	self baseExpression: localBase.
	self tablePrefix: ('s', anExpression ultimateBaseExpression availableSubSelectNumber printString, 't').
	^expression