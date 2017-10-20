accessing
valueDescriptor
	| valueMapping |
	valueMapping := self mappingForAttributeNamed: #value.
	valueMapping isNil ifTrue: [^nil].
	^valueMapping referenceDescriptor