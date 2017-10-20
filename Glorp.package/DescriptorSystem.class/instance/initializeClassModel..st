private
initializeClassModel: aClassModel
	| selector |
	selector := ('classModelFor' , aClassModel describedClass name , ':')
		asSymbol.
	(self respondsTo: selector)
		ifTrue: [^self perform: selector with: aClassModel].
	(aClassModel describedClass respondsTo: #glorpSetupClassModel:forSystem:)
		ifTrue:
			[^aClassModel describedClass
				glorpSetupClassModel: aClassModel
				forSystem: self].
	"Otherwise, just initialize it dynamically, so that old code with only descriptors will still work"
	^aClassModel