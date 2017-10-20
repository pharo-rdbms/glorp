tests-ordering
testDoubleOrderingAddress
	| query |
	query := Query read: GlorpAddress.
	query orderBy: [:each | each street].
	query orderBy: [:each | each number].
	self validateDoubleOrderFor: query.