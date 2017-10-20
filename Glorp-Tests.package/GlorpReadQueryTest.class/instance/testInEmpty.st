tests
testInEmpty
	"This test generates an error in DB2 because DB2 claims that IN (NULL) is invalid,
	since not even NULL can be IN (NULL) (since NULL isn't equal to itself)."

	| query result |
	session platform isDB2Platform ifTrue: [^self].
	query := Query read: GlorpAddress where: [:each | each street in: #()].
	result := session execute: query.
	self assert: result isEmpty