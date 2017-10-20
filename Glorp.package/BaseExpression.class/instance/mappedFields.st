accessing
mappedFields
	^self descriptor mappedFields collect: [:each | self translateField: each].