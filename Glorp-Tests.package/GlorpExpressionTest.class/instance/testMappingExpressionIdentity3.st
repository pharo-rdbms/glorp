tests
testMappingExpressionIdentity3

	self assertIdentityOf: [:a | a get: #someAttribute] and: [:a | a someAttribute].