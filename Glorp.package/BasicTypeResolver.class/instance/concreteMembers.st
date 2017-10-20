accessing
concreteMembers
	^concreteMembers isNil 
		ifTrue: [ concreteMembers := OrderedCollection new ]
		ifFalse: [ concreteMembers]