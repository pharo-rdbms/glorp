Class {
	#name : #GlorpExampleSystem,
	#superclass : #Object,
	#instVars : [
		'objects'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #initialization }
GlorpExampleSystem >> initialize [

	super initialize.
	objects := Dictionary new
]

{ #category : #misc }
GlorpExampleSystem >> lookupObject: aNumber ofClass: aClass ifAbsentPut: absentBlock [

	^(objects at: aClass ifAbsentPut: [Dictionary new]) at: aNumber ifAbsentPut: absentBlock.
]

{ #category : #api }
GlorpExampleSystem >> objectNumber: aNumber ofClass: aClass [

	| symbol instance|
	instance := self lookupObject: aNumber ofClass: aClass ifAbsentPut: [aClass new].
	symbol := ('example', aClass name, 'Number', aNumber printString, ':') asSymbol.
	self perform: symbol with: instance.
	^instance.
]
