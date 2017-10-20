tests-ordering
testMixedDoubleOrderingAddress
	| query |
	query := Query read: GlorpAddress.
	query orderBy: [:each | each street descending].
	query orderBy: [:each | each number].
	self validateDoubleOrderMixedFor: query.