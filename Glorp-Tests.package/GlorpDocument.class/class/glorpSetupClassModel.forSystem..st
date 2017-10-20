setup
glorpSetupClassModel: model forSystem: system 
	model
		newAttributeNamed: #id;
		newAttributeNamed: #whatever;
		newAttributeNamed: #attachments
			collection: OrderedCollection
			of: GlorpAttachment