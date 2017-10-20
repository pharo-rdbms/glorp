initializing
fieldsAndValidValuesDo: aBlock 
	"If iterating over fields and values, we include wrappers with no value assigned yet. This might or might not be what we want. This one just iterates over ones with actual values"
	self isEmpty ifTrue: [^self].
	table fields do: [:each |  | value |
		value := self at: each ifAbsent: [self class missingFieldIndicator].
		value == self class missingFieldIndicator ifFalse: [
			aBlock value: each value: value]].