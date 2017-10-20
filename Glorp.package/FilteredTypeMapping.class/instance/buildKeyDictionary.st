initialize-release
buildKeyDictionary
	| subclassDescriptor |
	keyDictionary := Dictionary new.
	key isNil ifFalse: [keyDictionary at: key put: descriptor describedClass].
	descriptor describedClass allSubclasses do: 
			[:each | 
			subclassDescriptor := descriptor system descriptorFor: each.
			(subclassDescriptor isNil 
				or: [subclassDescriptor typeMapping keyedBy isNil]) 
					ifFalse: 
						[keyDictionary at: subclassDescriptor typeMapping keyedBy
							put: subclassDescriptor describedClass]]