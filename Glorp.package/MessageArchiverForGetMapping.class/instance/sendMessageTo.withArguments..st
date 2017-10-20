expression creation
sendMessageTo: anExpression withArguments: arguments
	"Send our own particular message. Note that our arguments will have been wrapped as constant expressions, and we don't want that, so unwrap them"
	^anExpression getMapping: arguments first value named: (arguments at: 2) value