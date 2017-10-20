get/set
checkTargetType: anObject against: aClass
	"Check that anObject's type corresponds to aClass, which we expect as our values. We expect this to be a real object, not a collection."
	| targetModel |
	anObject yourSelf isNil ifTrue: [^self].
	aClass isNil ifTrue: [self error: 'No type to check against in class model'].
	anObject glorpIsCollection ifTrue: [(GlorpInvalidTypeError new object: anObject; expectedType: self collectionType) signal].
	targetModel := self system classModelFor: aClass.
	targetModel notNil ifTrue: [
		(targetModel matches: anObject)
			ifFalse: [(GlorpInvalidTypeError new object: anObject; expectedType: aClass) signal]]