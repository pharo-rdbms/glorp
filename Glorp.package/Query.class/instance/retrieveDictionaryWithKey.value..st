specifying retrievals
retrieveDictionaryWithKey: keyExpression value: valueExpression

	self collectionType: (GlorpDictionaryDescription new keyExpression: keyExpression; valueExpression: valueExpression)