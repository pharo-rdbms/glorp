accessing
maximumLobSizeToRetrieveDirectly
	^query isNil
		ifTrue: [super maximumLobSizeToRetrieveDirectly]
		ifFalse: [query maximumLobSizeToRetrieveDirectly].