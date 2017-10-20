accessing
subclassDescriptorsBuilt
	^subclassDescriptorsBuilt isNil
		ifTrue: [ subclassDescriptorsBuilt := false ]
		ifFalse: [ subclassDescriptorsBuilt ]