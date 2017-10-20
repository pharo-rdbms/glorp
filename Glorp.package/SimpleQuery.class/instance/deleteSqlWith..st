As yet unclassified
deleteSqlWith: aDictionary
	| result |
	self prepare.
	customCommand isNil ifFalse: [
		result := customCommand copy.
		result query: self; parameters: aDictionary; useBinding: session useBinding; session: session.
		^result].
	^QueryDeleteCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session.