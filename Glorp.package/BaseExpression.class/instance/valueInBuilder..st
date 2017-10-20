mapping
valueInBuilder: anElementBuilder
	"If we ever get here, this is because we're being used as the reverse of a direct to-many mapping, so we expect to have a descriptor with only one mapping, named #myValue"
	| mapping |
	mapping := self descriptor mappingForAttributeNamed: #myValue.
	^mapping valueInBuilder: anElementBuilder as: (self get: #myValue) field.