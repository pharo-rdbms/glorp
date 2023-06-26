Class {
	#name : #GlorpWorkerDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models - Worker'
}

{ #category : #other }
GlorpWorkerDescriptorSystem >> allTableNames [

	^#('GLORP_WORKER' 'GLORP_JOB' 'GLORP_WORKER_JOB_LINK').
]

{ #category : #other }
GlorpWorkerDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpJob;
		add: GlorpWorker;
		yourself
]

{ #category : #descriptors }
GlorpWorkerDescriptorSystem >> descriptorForGlorpJob: aDescriptor [ 
	"Note that the job table contains a FINISHED field, but the GlorpJob object doesn't. This field is determined only by membership in the finished or pending collections. In this particular case it's not very useful from a domain perspective, but it's interesting to be able to map. Similarly, whether a job is priority or not is not in the domain object, and is stored in the link table defining the relationship"

	| table |
	table := self tableNamed: 'GLORP_JOB'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id
				to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #description
				to: (table fieldNamed: 'DESCRIPTION')).
]

{ #category : #descriptors }
GlorpWorkerDescriptorSystem >> descriptorForGlorpWorker: aDescriptor [ 
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
]

{ #category : #examples }
GlorpWorkerDescriptorSystem >> exampleJobRow: anInteger finished: aBoolean [

	| table row |
	table := self tableNamed: 'GLORP_JOB'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: anInteger.
	row at: (table fieldNamed: 'DESCRIPTION') put: 'Job ', anInteger printString.
	row at: (table fieldNamed: 'FINISHED') put: (aBoolean ifTrue: ['Y'] ifFalse: ['N']).
	row at: (table fieldNamed: 'OWNER_ID') put: 1234.

	^row.
]

{ #category : #examples }
GlorpWorkerDescriptorSystem >> exampleLinkRow1 [

	| table row |
	table := self tableNamed: 'GLORP_WORKER_JOB_LINK'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'WORKER_ID') put: 1234.
	row at: (table fieldNamed: 'JOB_ID') put: 2.
	row at: (table fieldNamed: 'PRIORITY') put: 'N'.
	^row.
]

{ #category : #examples }
GlorpWorkerDescriptorSystem >> exampleLinkRow2 [

	| table row |
	table := self tableNamed: 'GLORP_WORKER_JOB_LINK'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'WORKER_ID') put: 1234.
	row at: (table fieldNamed: 'JOB_ID') put: 3.
	row at: (table fieldNamed: 'PRIORITY') put: 'Y'.
	^row.
]

{ #category : #examples }
GlorpWorkerDescriptorSystem >> exampleWorkerRow [

	| table row |
	table := self tableNamed: 'GLORP_WORKER'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 1234.
	row at: (table fieldNamed: 'NAME') put: 'John Worker'.
	^row.
]

{ #category : #tables }
GlorpWorkerDescriptorSystem >> tableForGLORP_JOB: aTable [

	| ownerId |
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'DESCRIPTION' type: (platform varChar: 40).
	aTable createFieldNamed: 'FINISHED' type: (platform varChar: 1).
	ownerId := aTable createFieldNamed: 'OWNER_ID' type: platform int4.
	aTable addForeignKeyFrom: ownerId
		to: ((self tableNamed: 'GLORP_WORKER') fieldNamed: 'ID').
]

{ #category : #tables }
GlorpWorkerDescriptorSystem >> tableForGLORP_WORKER: aTable [

	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
]

{ #category : #tables }
GlorpWorkerDescriptorSystem >> tableForGLORP_WORKER_JOB_LINK: aTable [

	| workerId jobId |
	workerId := aTable createFieldNamed: 'WORKER_ID' type: platform int4.
	aTable addForeignKeyFrom: workerId
		to: ((self tableNamed: 'GLORP_WORKER') fieldNamed: 'ID').
	jobId := aTable createFieldNamed: 'JOB_ID' type: platform int4.
	aTable addForeignKeyFrom: jobId
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'ID').
	aTable createFieldNamed: 'PRIORITY' type: (platform varChar: 1).
]

{ #category : #descriptors }
GlorpWorkerDescriptorSystem >> workerCriteriaWithConstant: aString in: table [ 
	^Join 
		from: (table fieldNamed: 'ID')
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'OWNER_ID')
		from: aString
		to: ((self tableNamed: 'GLORP_JOB') fieldNamed: 'FINISHED').
]
