types
typeNamed: aSymbol ifAbsentPut: aBlock

	| type |
	type := self types at: aSymbol ifAbsentPut: [
		| newType |
		newType := aBlock value.
		newType platform: self.
		newType selector: aSymbol].
	type hasParameters ifTrue: [type := type copy].
	^type.