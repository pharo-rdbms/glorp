accessing
getVisualWorksMessageText
	"In VisualWorks, we often get arrays of ExternalDatabaseExceptions, whose parameter is an array of ExternalDatabaseError objects. Or we might just get an exception, or we might get nil or something else entirely, in which case we fall back to a default error message."
	| dbError |
	self databaseError isNil ifTrue: [^messageText := self defaultMessageText].
	dbError := self databaseError.
	dbError glorpIsCollection ifTrue: [dbError := dbError first].
	messageText := [dbError dbmsErrorString] on: Error do: [:ex | 
		ex return: ([dbError messageText] on: Error do: [:anotherEx |
			anotherEx return: self defaultMessageText])].
	^messageText.