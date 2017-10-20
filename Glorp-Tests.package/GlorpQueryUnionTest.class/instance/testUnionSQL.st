tests-unit
testUnionSQL
	"Use expandMacros to avoid platform-specific line-end conventions blocking string matching."

	| query1 union command |
	query1 := Query read: GlorpAddress where: [:each | each id = 1].
	union := query1 unionAll: query1.
	union session: session.
	command := union sqlWith: #().
	self assert: ('SELECT * FROM (*SELECT *<n> FROM GR_ADDRESS t1<n> WHERE *t1.ID = * UNION ALL *SELECT *<n> FROM GR_ADDRESS t1<n> WHERE *t1.ID = *' expandMacros withUnixLineEndings match: command sqlString withUnixLineEndings).