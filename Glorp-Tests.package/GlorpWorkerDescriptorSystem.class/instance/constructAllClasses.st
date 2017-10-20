other
constructAllClasses
	^(super constructAllClasses)
		add: GlorpJob;
		add: GlorpWorker;
		yourself