tests
testMessageCollectorDNU
	| message caught |
	message := Message selector: #foo arguments: #().
	caught := false.
	[collector basicDoesNotUnderstand: message] on: MessageNotUnderstood
		do: [:signal | caught := true. signal sunitExitWith: nil].
	self assert: caught