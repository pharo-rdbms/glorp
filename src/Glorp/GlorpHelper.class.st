"
This is a helper class for methods that I'd like to be able to add as extensions, but don't want to for fear of conflicting with dialects that have them, or people who implement them for their own projects, and any other miscellaneous extensions. One extension is that this class is in the Smalltalk namespace, so is universally accessible, and it provides a way for class extensions that don't have visibility of the Glorp namespace to access the Dialect class.
"
Class {
	#name : 'GlorpHelper',
	#superclass : 'Object',
	#category : 'Glorp-Exceptions',
	#package : 'Glorp',
	#tag : 'Exceptions'
}

{ #category : 'classes' }
GlorpHelper class >> dialect [
	"Provide a way to refer to the dialect class from an extension or class that doesn't include the Glorp namespace, while still avoiding explicit namespace imports (which confuse other dialects when the 'pool dictionaries' don't exist)."

	| glorpNamespace |
	glorpNamespace := Smalltalk at: #Glorp ifAbsent: [ nil ].
	^ (glorpNamespace ifNil: [ Smalltalk ] ifNotNil: [ glorpNamespace ])
		  at: #Dialect
		  ifAbsent: [ Smalltalk at: #Dialect ]
]

{ #category : 'helpers' }
GlorpHelper class >> do: aBlock for: aCollection separatedBy: separatorBlock [

	| array |
	array := aCollection asArray.
	1 to: array size do: [:i |
		| each |
		each := array at: i.
		aBlock value: each.
		i = array size ifFalse: [
			separatorBlock value]]
]

{ #category : '*Glorp' }
GlorpHelper class >> glorpConstantExpressionClass [

	^ self dialect glorpConstantExpressionClass
]

{ #category : 'helpers' }
GlorpHelper class >> print: printBlock on: stream for: aCollection separatedBy: separatorString [

	| array |
	array := aCollection asArray.
	1 to: array size do: [:index |
		stream nextPutAll: (printBlock value: (array at: index)).
		index == array size ifFalse: [
			stream nextPutAll: separatorString]]
]

{ #category : 'helpers' }
GlorpHelper class >> separate: aCollection by: aOneArgumentBlock [

	^ aCollection inject: Dictionary new into: [ :dict :each |
		  | val |
		  val := aOneArgumentBlock value: each.
		  (dict at: val ifAbsentPut: [ OrderedCollection new ]) add: each ]
]
