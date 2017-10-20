support
setUp
	| descriptor |
	super setUp.
	mapping := DirectMapping from: #id to: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	descriptor := Descriptor new.
	descriptor classModel: (GlorpClassModel for: GlorpCustomer).
	descriptor addMapping: mapping.