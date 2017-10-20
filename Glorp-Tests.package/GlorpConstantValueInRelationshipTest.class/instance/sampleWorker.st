support
sampleWorker

	| worker job3 |
	worker := GlorpWorker new.
	worker id: 1234.
	worker name: 'Some Worker'.
	worker pendingJobs add: (GlorpJob new id: 1; description: 'job 1').
	worker pendingJobs add: (GlorpJob new id: 2; description: 'job 2').
	worker finishedJobs add: (job3 := GlorpJob new id: 3; description: 'job 3').
	worker finishedJobs add: (GlorpJob new id: 4; description: 'job 4').
	worker priorityJobs add: job3.
	^worker.