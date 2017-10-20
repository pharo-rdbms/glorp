api
reversedCorrespondenceMap
	(reversedCorrespondenceMap isNil
		or: [reversedCorrespondenceMap size ~= correspondenceMap size])
		ifTrue:
			[reversedCorrespondenceMap := IdentityDictionary
				new: correspondenceMap size.
			correspondenceMap
				keysAndValuesDo: [:k :v | reversedCorrespondenceMap at: v put: k]].
	^reversedCorrespondenceMap