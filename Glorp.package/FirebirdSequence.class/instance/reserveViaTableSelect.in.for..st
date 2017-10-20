sequencing
reserveViaTableSelect: anInteger in: aSession for: aTable
	"Interbase returns the top of the generated range in a single row. Do the iteration ourselves"
	| rows command max |
	command := self
		tableSelectCommandFor: aTable
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	command useBinding: false.
	rows := aSession accessor executeCommand: command.
	max := rows first first.
	max - anInteger + 1 to: max do: [:i | self reservedNumbers add: i].