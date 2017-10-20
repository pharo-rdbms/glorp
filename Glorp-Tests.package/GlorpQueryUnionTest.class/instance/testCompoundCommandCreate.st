tests-unit
testCompoundCommandCreate
	| query1 union command |
	query1 := Query read: GlorpAddress.
	union := query1 unionAll: query1.
	union session: session.
	command := union sqlWith: #().
	self assert: command class == CompoundSelectCommand.