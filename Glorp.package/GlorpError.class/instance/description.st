printing
description
	"Make sure that we've populated our messageText before calling the superclass implementation."
	self getMessageText.
	^super description.