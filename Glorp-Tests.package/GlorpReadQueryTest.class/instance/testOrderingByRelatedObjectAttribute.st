tests-ordering
testOrderingByRelatedObjectAttribute
	| query result |
	query := Query read: GlorpPerson.
	query orderBy: [:each | each address street].
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].