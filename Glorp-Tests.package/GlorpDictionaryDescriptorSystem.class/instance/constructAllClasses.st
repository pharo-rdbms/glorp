initialization
constructAllClasses
	^(super constructAllClasses)
		add: GlorpTaskedWorker;
		add: GlorpWorkerTask;
		yourself