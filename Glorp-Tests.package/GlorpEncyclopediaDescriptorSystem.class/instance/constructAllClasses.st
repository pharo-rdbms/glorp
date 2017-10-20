other
constructAllClasses
	^(super constructAllClasses)
		add: GlorpEncyclopedia;
		add: GlorpMediaType;
		add: GlorpEncyclopediaEntry;
		add: GlorpPublisher;
		add: GlorpPublisherEmployee;
		yourself