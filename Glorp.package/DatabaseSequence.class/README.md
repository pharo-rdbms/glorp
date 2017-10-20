This is an abstract superclass for identifier generation mechanisms in the database. For example, Oracle sequences, SQL Server identity columns, and so on.

Subclasses must implement the following messages:
	sequencing
		getSequenceValueFromDatabaseFor:in:using:
		postWriteAssignSequenceValueFor:in:using:

Instance Variables:
	reservedNumbers	<OrderedCollection>	Numbers that we have already reserved and have available. This is only useful if the sequence can generate more than one identifier in a single request, and we have configured it (and ourselves) to do so and use those numbers. This is useful for efficiency when inserting lots of data.

