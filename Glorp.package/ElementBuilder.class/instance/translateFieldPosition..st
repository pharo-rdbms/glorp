translating fields
translateFieldPosition: aDatabaseField 
	fieldTranslations isNil ifTrue: [^aDatabaseField position].
	^fieldTranslations at: aDatabaseField