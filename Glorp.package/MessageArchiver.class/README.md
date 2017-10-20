This is what we use to construct GlorpExpression trees out of blocks. An instance of MessageArchiver is passed into the block. It has a doesNotUnderstand: handler, and in response to almost any message, will just return a new MessageArchiver which knows it is descended from this one. The result (assuming no inlined messages or other tricky stuff happened) is a tree of MessageArchivers recording all the sent messages. We can then traverse that and construct the appropriate expression tree.

Instance Variables:
	myArguments	<(Collection of: (Object | ProtoObject))>	The arguments to the message that caused me to be constructed.
	myReceiver	<MessageArchiver | nil>	The object that received the message that caused me to be constructed. For the initial MessageArchiver that's passed in, this will be nil. Otherwise it is a MessageArchiver.
	mySelector	<Symbol>	The selector of the message that caused me to be constructed.
	query	<AbstractReadQuery>	The query for which I am constructing the expression. This is here so that we can construct the final expression tree directly onto its BaseExpression.

