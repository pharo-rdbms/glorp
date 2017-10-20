examples
examplePublisher1
	"Put in the copies to avoid an issue with reverting immutable objects."
	^GlorpPublisher new 
		id: 1;
		name: 'Cambridge';
		titles: (Array with: 'Mastering ENVY/Developer' copy with: 'Principia Mathematica' copy with:  'Metadata-Based Persistence for Dummies' copy);
		titlesWithNumberInStock: (Dictionary new
			at:  'Mastering ENVY/Developer' put: 2;
			at: 'Principia Mathematica' put: 2;
			at: 'Metadata-Based Persistence for Dummies' put: 2;
			yourself);
		employees: (Dictionary new
			at: 'CEO' put: (GlorpPublisherEmployee new id: 1; name: 'The Boss'; jobTitle: 'CEO');
			at: 'Editor' put: (GlorpPublisherEmployee new id: 2; name: 'Somebody'; jobTitle: 'Editor');
			yourself);
		differentBunchOfEmployeesById: (Dictionary new
			at: 3 put: (GlorpPublisherEmployee new id: 3; name: 'Contractor 1'; jobTitle: 'Contractor');
			at: 4 put: (GlorpPublisherEmployee new id: 4; name: 'Contractor 2'; jobTitle: 'Contractor');
			yourself);
		yourself.