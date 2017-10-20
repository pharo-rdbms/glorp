descriptors
descriptorForGlorpWorkerTask: aDescriptor
	| taskTable |
	taskTable := self tableNamed: 'GLORP_WORKER_TASK'.
	aDescriptor table: taskTable.
	(aDescriptor newMapping: DirectMapping) from: #id to: (taskTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #description to: (taskTable fieldNamed: 'DESCRIPTION').