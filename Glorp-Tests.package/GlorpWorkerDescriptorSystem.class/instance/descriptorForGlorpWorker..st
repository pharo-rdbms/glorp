descriptors
descriptorForGlorpWorker: aDescriptor 
	| table linkTable |
	table := self tableNamed: 'GLORP_WORKER'.
	aDescriptor table: table.
	aDescriptor 
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor 
		addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: ((OneToManyMapping new)
				attributeName: #pendingJobs;
				referenceClass: GlorpJob;
				join: (self workerCriteriaWithConstant: 'N' in: table)).
	aDescriptor addMapping: ((OneToManyMapping new)
				attributeName: #finishedJobs;
				referenceClass: GlorpJob;
				join: (self workerCriteriaWithConstant: 'Y' in: table)).
	linkTable := self tableNamed: 'GLORP_WORKER_JOB_LINK'.

	"Note that priorityJobs may include finished jobs as well, and instances may occur in both this collection and the other two"
	aDescriptor addMapping: ((ManyToManyMapping new)
				attributeName: #priorityJobs;
				referenceClass: GlorpJob;
				join: (Join 
							from: (table fieldNamed: 'ID')
							to: (linkTable fieldNamed: 'WORKER_ID')
							from: 'Y'
							to: (linkTable fieldNamed: 'PRIORITY'))).