accessing
valueField: aDatabaseField
	| mapping |
	mapping := self newMapping: DirectMapping.
	mapping attributeName: #value.
	mapping from: #value to: aDatabaseField.
	self valueMapping: mapping