"
Var binary type

Instance Variables
	width:		<Object>

width
	- xxxxx

"
Class {
	#name : 'GlorpVarBinaryType',
	#superclass : 'GlorpDatabaseType',
	#instVars : [
		'width'
	],
	#category : 'Glorp-Types',
	#package : 'Glorp',
	#tag : 'Types'
}

{ #category : 'testing' }
GlorpVarBinaryType >> hasParameters [
	"Return true if this has modifiable parameters. That is, when we return one of these, should we return a copy rather than trying to save space be re-using instances"
	^true.
]

{ #category : 'testing' }
GlorpVarBinaryType >> impliedSmalltalkType [
	^ByteArray.
]

{ #category : 'initialize-release' }
GlorpVarBinaryType >> initialize [
	super initialize.
	typeString := 'varbinary'
]

{ #category : 'testing' }
GlorpVarBinaryType >> isVariableWidth [
	"Return true if this type allows varying length data within a particular instance. e.g., this is true for a varchar, but false for a fixed size character field"
	^true.
]

{ #category : 'accessing' }
GlorpVarBinaryType >> width [
	^width.
]

{ #category : 'accessing' }
GlorpVarBinaryType >> width: anInteger [

	width := anInteger
]
