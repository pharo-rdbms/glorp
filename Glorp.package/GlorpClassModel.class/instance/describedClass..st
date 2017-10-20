accessing
describedClass: aClass
	describedClass := aClass.
	subclasses := aClass allSubclasses isEmpty ifTrue: [nil] ifFalse: [aClass allSubclasses asArray]