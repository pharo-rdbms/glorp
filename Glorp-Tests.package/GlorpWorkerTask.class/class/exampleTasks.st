as yet unclassified
exampleTasks
	| tasks |
	tasks := OrderedCollection new.
	tasks add: (GlorpWorkerTask new id: 1; description: 'Clean house'; yourself).
	tasks add: (GlorpWorkerTask new id: 2; description: 'Trim hedges  and mow lawn'; yourself).
	tasks add: (GlorpWorkerTask new id: 3; description: 'Grocery shopping'; yourself).
	tasks add: (GlorpWorkerTask new id: 4; description: 'Run errands'; yourself).
	tasks add: (GlorpWorkerTask new id: 5; description: 'Take a break'; yourself).
	^tasks