setup
glorpSetupDescriptor: aDesc forSystem: system 
	| t |
	t := system tableNamed: 'document'.
	aDesc table: t.
	(aDesc newMapping: DirectMapping) from: #id to: (t fieldNamed: 'id').
	(aDesc newMapping: DirectMapping) from: #whatever to: (t fieldNamed: 'whatever').
	(aDesc newMapping: OneToManyMapping)
		attributeName: #attachments;
		orderBy: [:ea | ea index]