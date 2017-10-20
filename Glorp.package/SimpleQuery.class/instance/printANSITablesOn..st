sql generation
printANSITablesOn: aCommand
	"Print ourselves using the JOIN... USING syntax. Note that we have to put the joins in the right order because we're not allowed to refer to tables not mentioned yet. Great syntax. Reminds me of Pascal. And so easy to deal with."

	| printer |
	printer := JoinPrinter for: self.
	printer printJoinsOn: aCommand