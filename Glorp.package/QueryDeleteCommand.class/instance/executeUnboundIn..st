executing
executeUnboundIn: anAccessor
	anAccessor returnRowCount: true.
	anAccessor
		executeSQLStringNoResult: self sqlString
			doing: [self rowCount: anAccessor rowCount]
			forCommand: self.
	session platform supportsRowCount ifFalse: [self rowCount: nil   "Make sure it's clearly not a valid value"].
	^#() readStream.