examples
exampleGlorpPersonNumber1: aPerson 
	aPerson id: 1.
	aPerson name: 'Barney Rubble'.
	aPerson address: (self objectNumber: 1 ofClass: GlorpAddress).	
	aPerson emailAddress: (self objectNumber: 1 ofClass: GlorpEmailAddress).