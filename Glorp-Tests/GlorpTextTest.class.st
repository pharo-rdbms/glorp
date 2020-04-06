Class {
	#name : #GlorpTextTest,
	#superclass : #AbstractLOBTest,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpTextTest >> defaultDatabaseType [
	^self platform text
]

{ #category : #tests }
GlorpTextTest >> longString [
	"Make a significant sized stringlob. 64k+ a bit should do"
	| stream |
	stream := WriteStream on: (String new: 10000).
	(((2 raisedTo: 16) + 100.0) / 255.0) ceiling timesRepeat: [
		stream nextPutAll: self string255].
	^stream contents.
]

{ #category : #tests }
GlorpTextTest >> string255 [
	^'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstu'.
]

{ #category : #tests }
GlorpTextTest >> testLargeText [
	"For Access, the long test here not only fails, it messes up the driver so that other tests fail"
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	"(session platform class == AccessPlatform and: [session useBinding not])
		ifTrue: [^self]."
	self helpTestValue: self longString.
]

{ #category : #tests }
GlorpTextTest >> testSymbol [
	"Test that we can store a Symbol as text. This is particularly interesting because then we have to go through a non-empty type converter, and those need to take into account that text type, although a string type, probably doesn't have a maximum width."
	stType := Symbol.
	self helpTestValue: #'ASymbolStoredAsText'.
]

{ #category : #tests }
GlorpTextTest >> testText [
"	self helpTestValue: nil."
	self helpTestValue: 'Now is the time for all good squeakers to come to the aid of the mouse'.
]
