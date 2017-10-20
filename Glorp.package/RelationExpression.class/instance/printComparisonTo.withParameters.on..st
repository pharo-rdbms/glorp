printing SQL
printComparisonTo: value withParameters: aDictionary on: aStream
	"Horribly convoluted logic to handle the cases where the value might be a constant, an expression that results in a value (constant or parameter) or a regular expression, with the caveat that any value that turns out to be null has to be printed with IS NULL rather than = NULL."

	| translated |
	translated := self convertValueOf: value in: aDictionary.
	translated isGlorpExpression
		ifTrue:
			[
			translated canPrint ifTrue: [
				self printRelationOn: aStream.
				translated
					printSQLOn: aStream
					withParameters: aDictionary]]
		ifFalse:
			[self
				printSimpleValueComparisonTo: translated
				on: aStream].