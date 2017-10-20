support
readPerson
	| results query |
	query := Query
		read: GlorpPerson
		where: [:pers | pers id = personId].
	results := query executeIn: session.
	self assert: results size = 1.
	person := results first.