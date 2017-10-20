examples
examplePublisher1
	"Put in the copies to avoid an issue with reverting immutable objects."
	^GlorpTinyPublisher new 
		id: 1;
		name: 'Cambridge';
		titles: (Array with: 'Mastering ENVY/Developer' copy with: 'Principia Mathematica' copy with:  'Metadata-Based Persistence for Dummies' copy);
		titlesWithNumberInStock: (Dictionary new
			at:  'Mastering ENVY/Developer' put: 2;
			at: 'Principia Mathematica' put: 2;
			at: 'Metadata-Based Persistence for Dummies' put: 2;
			yourself).