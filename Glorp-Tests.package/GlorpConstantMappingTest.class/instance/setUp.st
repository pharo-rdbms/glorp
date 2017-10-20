support
setUp
	| descriptor |
	super setUp.
	mappingToClass := ConstantMapping new
		attributeName: #slot;
		constantValue: 34.
	descriptor := Descriptor new.
	descriptor classModel: (GlorpClassModel for: self class).
	descriptor addMapping: mappingToClass.
	mappingToRow := ConstantMapping new.
	mappingToSession := ConstantMapping new