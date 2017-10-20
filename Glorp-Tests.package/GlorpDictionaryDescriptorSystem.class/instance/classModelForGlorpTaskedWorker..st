classes
classModelForGlorpTaskedWorker: aClassModel
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #tasks collection: Dictionary of: GlorpWorkerTask