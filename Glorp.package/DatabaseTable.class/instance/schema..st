accessing
schema: aString

	schema := aString.
	parent isNil ifTrue: [
		self sequences do: [:each | each schema: aString]].