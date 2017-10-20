as yet unclassified
glorpSetupDescriptor: aDesc forSystem: system 
	| t |
	t := system tableNamed: 'attachmentbytes'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #content
		to: (t fieldNamed: 'content')