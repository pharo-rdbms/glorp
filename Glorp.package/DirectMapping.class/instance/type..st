accessing
type: aClass
	self attribute type: aClass.
	field isNil ifFalse: [
		self setConverterBetween: aClass and: field]