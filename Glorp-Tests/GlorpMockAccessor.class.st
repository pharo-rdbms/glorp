Class {
	#name : #GlorpMockAccessor,
	#superclass : #DatabaseAccessor,
	#category : 'Glorp-Tests-Database'
}

{ #category : #executing }
GlorpMockAccessor >> basicExecuteSQLString: aString [
	^ReadStream on: #(#(3)).
]

{ #category : #executing }
GlorpMockAccessor >> executeCommand: aCommand returnCursor: aBoolean [
	| result |
	result := #(#(3)).
	^aBoolean ifTrue: [result readStream] ifFalse: [result].
]

{ #category : #executing }
GlorpMockAccessor >> executeSQLString: aString [
	^#((3)).
]

{ #category : #accessing }
GlorpMockAccessor >> schema [
	^''
]
