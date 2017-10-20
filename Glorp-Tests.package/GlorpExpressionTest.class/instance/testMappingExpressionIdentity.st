tests
testMappingExpressionIdentity
 
	self assertIdentityOf: [:a | a someAttribute] and: [:a | a someAttribute].