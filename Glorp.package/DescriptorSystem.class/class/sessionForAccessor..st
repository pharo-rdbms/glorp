instance creation
sessionForAccessor: aDatabaseAccesor.
	"Create a session associated with the given accesseor, and using us as a descriptor system. 
	This is the easiest way to get a full blown session going."
	
	^(GlorpSession forSystem: (self forPlatform: aDatabaseAccesor platform))
		accessor: aDatabaseAccesor;
		yourself
