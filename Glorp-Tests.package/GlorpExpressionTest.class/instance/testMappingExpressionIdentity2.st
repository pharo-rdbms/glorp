tests
testMappingExpressionIdentity2

	self assertIdentityOf: [:a | a perform: #someAttribute] and: [:a | a someAttribute].