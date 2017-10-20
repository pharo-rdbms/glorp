processing
trace: aTracing context: anExpression
	"Currently we don't trace relationships across tables, so all we do here
is accumulate the list of embedded mappings"
	| newContext |
	(aTracing tracesThrough: self) ifFalse: [^self].
	newContext := anExpression get: self attributeName.
	aTracing addExpression: newContext.
	self referenceDescriptor trace: aTracing context: newContext.