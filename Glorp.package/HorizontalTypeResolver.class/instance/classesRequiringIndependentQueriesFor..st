accessing
classesRequiringIndependentQueriesFor: aClass
	^(self descriptorsRequiringIndependentQueriesFor: aClass) collect: [:each |
		each describedClass]