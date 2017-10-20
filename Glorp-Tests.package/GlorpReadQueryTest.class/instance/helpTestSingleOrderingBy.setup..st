tests-ordering
helpTestSingleOrderingBy: aBlock setup: setupBlock

	| query result realBlock |
	query := Query read: GlorpAddress.
	query orderBy: aBlock.
	realBlock := query expressionBlockFor: aBlock.
	result := session execute: query.
	self verifyOrderFor: result byAttribute: realBlock.