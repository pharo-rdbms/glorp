mapping
expressionFor: anObject basedOn: anExpression relation: aSymbol
	"Return our expression using the object's values. e.g. if this was a direct mapping from id->ID and the object had id: 3, then return TABLE.ID=3. Used when rewriting object=object into field=field"

	| myValue result |
	myValue := self expressionFor: anObject.
	result := nil.
	myValue with: self join allTargetFields do: [:eachValue :eachField |
		| source |
		source := anExpression get: self attribute name.
		source hasDescriptor ifTrue: [source := source getField: eachField].
		result := (source get: aSymbol withArguments: (Array with: eachValue)) AND: result].
	^result