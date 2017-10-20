descriptors/other
classModelForGlorpRecordWithUpdateTime: aClassModel

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #updateTime type: Dialect timestampClass.
	aClassModel newAttributeNamed: #updateSomeOtherThing type: String.