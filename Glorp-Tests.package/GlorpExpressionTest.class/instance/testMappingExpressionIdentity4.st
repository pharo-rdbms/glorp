tests
testMappingExpressionIdentity4

	self denyIdentityOf: [:a | a get: #someAttribute] and: [:a | a someOtherAttribute].