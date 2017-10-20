descriptors
descriptorForGlorpTaskedWorker: aDescriptor
	| workerTable linkTable |
	workerTable := self tableNamed: 'GLORP_TASKED_WORKER'.
	linkTable := self tableNamed: 'GLORP_TWO_WAY_LINK'.
	aDescriptor table: workerTable.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (workerTable fieldNamed: 'ID')).
	aDescriptor 
		addMapping: (DirectMapping from: #name to: (workerTable fieldNamed: 'NAME')).

	(aDescriptor newMapping: DictionaryMapping)
				attributeName: #tasks;
				referenceClass: GlorpWorkerTask;
				keyField: (linkTable fieldNamed: 'KEY_COLUMN');
				relevantLinkTableFields: (Array with: (linkTable fieldNamed: 'RIGHT_ID'))