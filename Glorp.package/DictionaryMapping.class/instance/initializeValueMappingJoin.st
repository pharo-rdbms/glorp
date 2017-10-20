initializing
initializeValueMappingJoin
	| tables |
	"We don't know which of these will come first in the descriptor, so call the other initialization if it looks like we have enough information, and it hasn't been done"
	self referenceDescriptor isNil ifTrue: [self initializeValueMapping].
	"Have we already done this?"
	self referenceDescriptor tables isEmpty ifFalse: [^self].

	tables := self targetTables asArray.
	tables do: [:each | self referenceDescriptor addTable: each].
	(self referenceDescriptor newMapping: DirectMapping) 
		from: #key to: self keyField.
	self mapsSimpleObject 
		ifTrue: [
			(self referenceDescriptor newMapping: DirectMapping) 
			from: #value to: self valueField]
		ifFalse: [
			(self referenceDescriptor newMapping: OneToOneMapping)
				attributeName: #value;	
				linkFields: self linkFields;
				usesLinkTable: self usesLinkTable;
				join: self join;
				controlsTables: false].