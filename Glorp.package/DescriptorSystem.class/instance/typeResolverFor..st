api
typeResolverFor: aClassOrObject 

	| theClass |
	aClassOrObject == Proxy ifTrue: [self error: 'Cannot find type resolver for the class Proxy. Pass in the instance'].
	theClass := aClassOrObject glorpCanHaveDescriptorDirectly 
				ifTrue: [aClassOrObject]
				ifFalse: [aClassOrObject isGlorpProxy ifTrue: [aClassOrObject getValue class] ifFalse: [aClassOrObject class]].
	^typeResolvers at: theClass ifAbsentPut: [self newTypeResolverFor: theClass]