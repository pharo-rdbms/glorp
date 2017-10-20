accessing
fieldsNeedingUpdate
	^self shouldUpdateOnlyChangedFields 
		ifTrue: [row fieldsNeedingUpdate]
		ifFalse: [row nonPrimaryKeyFields]