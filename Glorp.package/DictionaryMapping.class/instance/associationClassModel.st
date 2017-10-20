mapping
associationClassModel
	| model |
	model := GlorpClassModel for: Association.
	model newAttributeNamed: #key.
	model newAttributeNamed: #value.
	^model