private
newTypeResolverFor: aClass 
	| selector |
	(self allClasses includes: aClass) ifFalse: [^nil].
	selector := ('typeResolverFor' , aClass name) asSymbol.
	^(self respondsTo: selector) 
		ifTrue: [self perform: selector]
		ifFalse: [aClass glorpTypeResolver]