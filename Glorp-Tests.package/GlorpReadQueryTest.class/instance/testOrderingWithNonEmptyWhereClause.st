tests-ordering
testOrderingWithNonEmptyWhereClause

	| query result |
	query := Query read: GlorpPerson where: [:each | each id ~= 12].
	query orderBy: #(#address #street).
	result := session execute: query.
	self verifyOrderFor: result byAttribute: [:each | each address street].