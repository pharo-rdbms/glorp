Class {
	#name : #GlorpClobTest,
	#superclass : #AbstractLOBTest,
	#category : #'Glorp-Integration-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpClobTest >> defaultDatabaseType [
	^self platform clob.
]

{ #category : #tests }
GlorpClobTest >> longString [
	"Make a significant sized stringlob. 64k+ a bit should do"
	| stream |
	stream := WriteStream on: (String new: 10000).
	(((2 raisedTo: 16) + 100.0) / 255.0) ceiling timesRepeat: [
		stream nextPutAll: self string255].
	^stream contents.
]

{ #category : #tests }
GlorpClobTest >> string255 [
	^'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstu'.
]

{ #category : #tests }
GlorpClobTest >> testClob [
	self helpTestValue: nil.
	self helpTestValue: 'abcdef'.
]

{ #category : #tests }
GlorpClobTest >> testLargeClob [
	"The long test here not only fails, it messes up the driver so that other tests fail"
	self platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	"(session platform class == AccessPlatform and: [session useBinding not])
		ifTrue: [^self]."
	self helpTestValue: self longString.
]
