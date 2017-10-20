examples
examplePublisher2
	^GlorpPublisher new 
		id: 2;
		name: 'Harper Collins';
		titles: (Array with: 'A book' copy);
		titlesWithNumberInStock: (Dictionary new
			at:  'A book' copy put: 200;
			yourself).