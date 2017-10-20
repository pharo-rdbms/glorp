initialize
postInitializeIn: aDescriptorSystem
	"Any initialization that happens after all the fields have been added"
	1 to: fields size do: [:i |
		| each | 
		"If fields were read from the database, set their position now"
		each := fields at: i.
		each table: self.
		each position: i.
		each postInitializeIn: aDescriptorSystem].