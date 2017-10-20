accessing
messageText
	(messageText isNil or: [messageText isEmpty]) ifTrue: [
		messageText := self getMessageText].
	^messageText.