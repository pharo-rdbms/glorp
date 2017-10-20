accessing
typeResolver
	typeResolver isNil
		ifTrue: [  IdentityTypeResolver new register: self  ].
	^typeResolver