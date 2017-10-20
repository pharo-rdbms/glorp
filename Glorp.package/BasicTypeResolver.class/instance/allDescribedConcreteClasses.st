private
allDescribedConcreteClasses
	self subclassDescriptorsBuilt ifFalse: [self forceSubclassDescriptorLoads].
	^self concreteMembers collect: [ :each | each describedClass ]