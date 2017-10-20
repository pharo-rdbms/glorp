api
objectNumber: aNumber ofClass: aClass

	| symbol instance|
	instance := self lookupObject: aNumber ofClass: aClass ifAbsentPut: [aClass new].
	symbol := ('example', aClass name, 'Number', aNumber printString, ':') asSymbol.
	self perform: symbol with: instance.
	^instance.