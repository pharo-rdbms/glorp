Class {
	#name : #GlorpConstantMappingTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'mappingToClass',
		'mappingToRow',
		'mappingToSession',
		'slot'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpConstantMappingTest >> setUp [
	| descriptor |
	super setUp.
	mappingToClass := ConstantMapping new
		attributeName: #slot;
		constantValue: 34.
	descriptor := Descriptor new.
	descriptor classModel: (GlorpClassModel for: self class).
	descriptor addMapping: mappingToClass.
	mappingToRow := ConstantMapping new.
	mappingToSession := ConstantMapping new
]

{ #category : #tests }
GlorpConstantMappingTest >> testConstantInClass [

	slot := nil.
	mappingToClass mapObject: self inElementBuilder: nil.
	self assert: slot equals: 34
]

{ #category : #tests }
GlorpConstantMappingTest >> testConstantInClassDoesNotWriteToRow [
	"Would raise an exception if it tried to write into nil"

	mappingToClass mapFromObject: self intoRowsIn: nil
]

{ #category : #tests }
GlorpConstantMappingTest >> testGetValue [

	slot := nil.
	self assert: (mappingToClass getValueFrom: self) equals: 34
]

{ #category : #tests }
GlorpConstantMappingTest >> testSessionValue [
	mappingToClass constantValueIsSession.
	self assert: (mappingToClass constantValueIn: 38)== 38.
]
