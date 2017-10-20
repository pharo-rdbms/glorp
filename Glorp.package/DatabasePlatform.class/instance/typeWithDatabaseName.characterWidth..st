types
typeWithDatabaseName: aString characterWidth: aNumber
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	| baseType matchingTypes simpleTypes |
	matchingTypes := self typesWithValues values asArray select: [:each | each typeName asLowercase = aString asLowercase].
	matchingTypes isEmpty ifTrue: [
		Transcript cr; show: 'Cannot find type ', aString, ' using integer instead.'. matchingTypes := Array with: self integer].
	"We may get generated and non-generated both matching, e.g. inMemorySequence and int. Prefer the non-generated."
	simpleTypes := matchingTypes reject: [:each | each isGenerated].
	baseType := simpleTypes isEmpty ifTrue: [matchingTypes first] ifFalse: [simpleTypes first].
	^baseType hasWidth ifTrue: [baseType copy width: aNumber] ifFalse: [baseType].