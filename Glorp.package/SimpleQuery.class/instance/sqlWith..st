sql generation
sqlWith: aDictionary
	| result |
	self prepare.
	customCommand isNil ifFalse: [
		result := customCommand copy.
		result query: self; parameters: aDictionary; useBinding: session useBinding; session: session.
		^result].
	^QuerySelectCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session