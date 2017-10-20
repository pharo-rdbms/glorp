mapping
allDescribedConcreteClasses
	| col |
	col := OrderedCollection new
		add: self describedClass;
		addAll: self describedClass allSubclasses;
		yourself.
	self needsWork: 'This belongs in someone else''s responsibility'.
	^col select: [:each |
		(self system descriptorFor: each) typeMapping isAbstract not ]