accessing
constructAllClasses
	^(super constructAllClasses)
		add: GlorpUser;
		add: GlorpFolder;
		add: GlorpMessage;
		yourself