"
This represents a function that takes no arguments and is complete in itself. The obvious example is COUNT(*). Making a special '*' pseudo-field seems even more of a hack than just hard-coding it into a function like this. It's possible that things like nextval(sequence) might be able to fall in this category too.
"
Class {
	#name : #StandaloneFunction,
	#superclass : #FunctionExpression,
	#category : 'Glorp-Expressions'
}

{ #category : #accessing }
StandaloneFunction >> field [
	^nil.
]

{ #category : #mapping }
StandaloneFunction >> mappedFields [
	^Array with: self.
]

{ #category : #printing }
StandaloneFunction >> printSQLOn: aStream withParameters: aDictionary [
	aStream nextPutAll: ' '; nextPutAll: function.
]

{ #category : #accessing }
StandaloneFunction >> type [
	type isNil ifFalse: [^type].
	^self defaultType.
]

{ #category : #mapping }
StandaloneFunction >> valueInBuilder: anElementBuilder [
	^anElementBuilder valueOfField: self
]

{ #category : #mapping }
StandaloneFunction >> valueInBuilder: anElementBuilder as: anExpression [
	^anElementBuilder valueOfField: anExpression.
]
