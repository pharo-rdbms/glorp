support
setUp
	super setUp.
	descriptors := system allDescriptors.
	dbPlatform := system platform.
	GlorpInMemorySequenceDatabaseType reset