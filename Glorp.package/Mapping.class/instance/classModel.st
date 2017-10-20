accessing
classModel
	"If we don't have one, just make a temporary one. We'll fix it later"
	descriptor isNil ifTrue: [^GlorpClassModel new].
	^self descriptor classModel.