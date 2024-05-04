"
This is a descriptor system whose descriptors and tables are created dynamically rather than out of generated code. Note that identity is extremely important, so care is required to set these up properly.

"
Class {
	#name : 'DynamicDescriptorSystem',
	#superclass : 'DescriptorSystem',
	#instVars : [
		'attributeNameToFieldNameBlock'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'accessing' }
DynamicDescriptorSystem >> addEmptyDescriptorFor: aClass [ 
	| descriptor |
	descriptor := Descriptor new.
	descriptor system: self.
	self privateDescriptorAt: aClass put: descriptor.
	descriptor classModel: (self classModelFor: aClass).
	^descriptor
]

{ #category : 'accessing' }
DynamicDescriptorSystem >> addEmptyTableNamed: aString [ 
	| table |
	table := self databaseTableClass named: aString.
	self privateTableAt: aString put: table.
	^table
]

{ #category : 'accessing' }
DynamicDescriptorSystem >> allClasses [
	^descriptors keys
]

{ #category : 'accessing' }
DynamicDescriptorSystem >> allTableNames [
	^tables keys
]

{ #category : 'accessing' }
DynamicDescriptorSystem >> attributeNameToFieldNameBlock: aBlock [
	attributeNameToFieldNameBlock := aBlock
]

{ #category : 'hooks' }
DynamicDescriptorSystem >> fieldNameForAttributeName: aSymbol [ 
	attributeNameToFieldNameBlock isNil  
		ifTrue: [^super fieldNameForAttributeName: aSymbol].
	^attributeNameToFieldNameBlock value: aSymbol
]

{ #category : 'accessing' }
DynamicDescriptorSystem >> initializeClassModel: aClassModel [
	"Assume we'll initialize it either before or after this"
]

{ #category : 'private' }
DynamicDescriptorSystem >> privateDescriptorAt: aClass put: aDescriptor [
	"Normally you don't want to be setting tables explicitly, as it may defeat the identity management but it's here if needed"
	descriptors at: aClass put: aDescriptor
]

{ #category : 'private' }
DynamicDescriptorSystem >> privateTableAt: aString put: aTable [
	"Normally you don't want to be setting tables explicitly, as it may defeat the identity management but it's here if needed"
	tables at: aString asUppercase put: aTable
]
