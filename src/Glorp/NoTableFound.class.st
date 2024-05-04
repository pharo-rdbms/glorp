"
NoTableFound is raise if there is possible mismatch between an active record and database table names

Instance Variables:
	expectedTables	<OrderedCollection>	 expected table names to map the model


"
Class {
	#name : 'NoTableFound',
	#superclass : 'ValidationError',
	#instVars : [
		'expectedTables'
	],
	#category : 'Glorp-Exceptions',
	#package : 'Glorp',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
NoTableFound >> expectedTables [

	^ expectedTables
]

{ #category : 'accessing' }
NoTableFound >> expectedTables: aCollection [

	expectedTables := aCollection
]

{ #category : 'accessing' }
NoTableFound >> messageText [

	messageText ifNotNil: [^messageText].
	self model isString ifTrue: [^'No table <1s> found' expandMacrosWith: self model].
	^'No table found for <1s>, expected to see one of  <2s>' expandMacrosWith: self model name with: self expectedTables printString
]

{ #category : 'printing' }
NoTableFound >> printOn: aStream [

	aStream nextPutAll: self messageText
]
