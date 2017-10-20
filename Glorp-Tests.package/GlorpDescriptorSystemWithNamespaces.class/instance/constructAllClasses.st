accessing
constructAllClasses
	^(super constructAllClasses)
		add: GlorpTestClassInNamespace;
		yourself