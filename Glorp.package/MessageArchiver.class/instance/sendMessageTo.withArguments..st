expression creation
sendMessageTo: anExpression withArguments: arguments
	"Build our node by sending our message to anExpression"

	^anExpression get: mySelector withArguments: arguments