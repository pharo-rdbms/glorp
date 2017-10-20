accessing
descriptorsRequiringIndependentQueriesFor: aClass
	^self concreteMembers select: [ :each | each describedClass includesBehavior: aClass ]