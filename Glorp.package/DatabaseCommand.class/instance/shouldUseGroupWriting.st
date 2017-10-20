testing
shouldUseGroupWriting
	^(self hasMultipleRows and: [self platform supportsGroupWritingFor: self])