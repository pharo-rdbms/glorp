executing
subCommands
	| startPosition commands endPosition subRows newCommand |
	startPosition := 1.
	commands := OrderedCollection new.
	[startPosition > allRows size] whileFalse: [
		endPosition := (startPosition + self maximumSingleWriteSize - 1) min: allRows size.
		subRows := allRows copyFrom: startPosition to: endPosition.
		newCommand := self class forRows: subRows useBinding: self useBinding session: self session.
		commands add: newCommand.
		startPosition := endPosition + 1].
	^commands.