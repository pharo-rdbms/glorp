printing
displayString

	| stream |
	stream := String new writeStream.
	self printOnlySelfOn: stream.
	^stream contents.