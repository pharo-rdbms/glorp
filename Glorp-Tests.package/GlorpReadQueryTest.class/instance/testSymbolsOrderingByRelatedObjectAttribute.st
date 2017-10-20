tests-ordering
testSymbolsOrderingByRelatedObjectAttribute

	| query result |
	query := Query read: GlorpPerson.
	query orderBy: #(#address #street).
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].