tests
messageCollectorDNUObjectStudio
	| caught |
	caught := false.
	[collector basicDoesNotUnderstand: #foo args: #()] on: MessageNotUnderstood
		do: [:signal | caught := true. signal sunitExitWith: nil].
	self assert: caught