This is a superclass for mappings which represent a relationship between one object and a collection of others. It isn't an abstract superclass, you can use this class directly, and you will get the same behaviour as if you were using OneToManyMapping. Or if you set useLinkTable to true, you'll get the same behaviour as a ManyToManyMapping.

Instance Variables:
	orderBy	<(SequenceableCollection of: (GlorpExpression | BlockClosure))>	By what criteria should we order the collection of items when we are reading.
	shouldWriteTheOrderField	<Boolean>	On write, when we write an item in the collection, should we also write the index at which it occurs in the collection into the database. This lets us preserve ordering if we just used a SequenceableCollection in memory. If this is true, we assume that the first item in orderBy will give us the field to write the index into.

