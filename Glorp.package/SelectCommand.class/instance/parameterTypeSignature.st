accessing
parameterTypeSignature
	| result |
	result := WriteStream on: String new.
	self bindings do: [:each | result nextPutAll: each class name].
	^result contents.