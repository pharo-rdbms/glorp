Class {
	#name : #GlorpDictionaryDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpDictionaryDescriptorSystem >> allTableNames [
	^#('GLORP_TASKED_WORKER' 'GLORP_TWO_WAY_LINK' 'GLORP_WORKER_TASK')
]

{ #category : #classes }
GlorpDictionaryDescriptorSystem >> classModelForGlorpTaskedWorker: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #name.
	aClassModel newAttributeNamed: #tasks collection: Dictionary of: GlorpWorkerTask
]

{ #category : #classes }
GlorpDictionaryDescriptorSystem >> classModelForGlorpWorkerTask: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #description.
]

{ #category : #initialization }
GlorpDictionaryDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpTaskedWorker;
		add: GlorpWorkerTask;
		yourself
]

{ #category : #descriptors }
GlorpDictionaryDescriptorSystem >> descriptorForGlorpTaskedWorker: aDescriptor [
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
]

{ #category : #descriptors }
GlorpDictionaryDescriptorSystem >> descriptorForGlorpWorkerTask: aDescriptor [
	| taskTable |
	taskTable := self tableNamed: 'GLORP_WORKER_TASK'.
	aDescriptor table: taskTable.
	(aDescriptor newMapping: DirectMapping) from: #id to: (taskTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #description to: (taskTable fieldNamed: 'DESCRIPTION').
]

{ #category : #tables }
GlorpDictionaryDescriptorSystem >> tableForGLORP_TASKED_WORKER: aTable [
	| id |
	id := aTable createFieldNamed: 'ID' type: platform int4.
	id bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varchar: 30).
]

{ #category : #tables }
GlorpDictionaryDescriptorSystem >> tableForGLORP_TWO_WAY_LINK: aTable [
	| leftId rightId |
	leftId := aTable createFieldNamed: 'LEFT_ID' type: platform int4.
	leftId bePrimaryKey.
	rightId := aTable createFieldNamed: 'RIGHT_ID' type: platform int4.
	rightId bePrimaryKey.
	aTable addForeignKeyFrom: leftId to: ((self tableNamed: 'GLORP_TASKED_WORKER') fieldNamed: 'ID').
	aTable addForeignKeyFrom: rightId to: ((self tableNamed: 'GLORP_WORKER_TASK') fieldNamed: 'ID').
	aTable createFieldNamed: 'KEY_COLUMN' type: (platform varChar: 10).
	aTable createFieldNamed: 'UNUSED_COLUMN' type: (platform varChar: 10).
]

{ #category : #tables }
GlorpDictionaryDescriptorSystem >> tableForGLORP_WORKER_TASK: aTable [
	| id |
	id := aTable createFieldNamed: 'ID' type: platform int4.
	id bePrimaryKey.
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varchar: 30).
]
