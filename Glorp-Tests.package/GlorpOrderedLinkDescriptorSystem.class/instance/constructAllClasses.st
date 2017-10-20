initialize-release
constructAllClasses

	^(super constructAllClasses)
		add: GlorpTravelFolder;
		add: GlorpTravelFile;
		yourself