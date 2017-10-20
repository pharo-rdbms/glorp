sequences
databaseSequenceClass
	"My AccessPlatform subclass has a hardcoded check in StoreDescriptorSystem>>sequenceFor: to ignore this method in favour of calling #justSelectTheMaximumCurrentValueAndAddOneSequenceFor: for AccessPlatform.  Can we retire that?"

	^SQLServerSequence