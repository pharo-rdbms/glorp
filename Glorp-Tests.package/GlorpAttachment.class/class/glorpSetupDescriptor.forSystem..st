as yet unclassified
glorpSetupDescriptor: aDesc forSystem: system 
	| t |
	t := system tableNamed: 'attachment'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #index
		to: (t fieldNamed: 'indexInDocument').
	(aDesc newMapping: DirectMapping) from: #mimeType
		to: (t fieldNamed: 'mimetype').
	(aDesc newMapping: OneToOneMapping) attributeName: #attachmentBytes