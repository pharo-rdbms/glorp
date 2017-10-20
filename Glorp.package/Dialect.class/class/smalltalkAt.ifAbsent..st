class lookup
smalltalkAt: aName ifAbsent: aBlock
	"We may look these names up a lot, so cache them in a small, local dictionary"
	| cached value symbol |
	symbol := aName asSymbol.
	cached := self lookedUpNames at: symbol ifAbsent: [nil].
	cached isNil ifFalse: [
		(cached isBehavior and: [cached isObsolete]) ifFalse: [^cached]].
	value := Smalltalk at: symbol ifAbsent: aBlock.
	self lookedUpNames
		at: symbol
		put: value.
	^value