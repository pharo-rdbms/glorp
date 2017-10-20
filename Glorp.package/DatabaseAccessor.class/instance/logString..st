private
logString: aString

	| stringToLog |
	stringToLog := aString size > 4000 
		ifTrue: [aString copyFrom: 1 to: 4000]
		ifFalse: [aString].
	self logger
		cr;
		show: stringToLog.
	(self logOnly and: [stringToLog notEmpty and: [stringToLog last ~= $;]])
		ifTrue: [self logger show: ';'].