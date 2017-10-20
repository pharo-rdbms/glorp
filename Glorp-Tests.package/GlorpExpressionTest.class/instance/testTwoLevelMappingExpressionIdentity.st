tests
testTwoLevelMappingExpressionIdentity

	self assertIdentityOf: [:a | a someAttribute someAttribute] and: [:a | a someAttribute someAttribute].
	self denyIdentityOf: [:a | a someAttribute someAttribute] and: [:a | a someAttribute].