This represents a foreign key constraint in the database. It's used during table creation, but more important it's used when calculating the order in which we need to write rows. Also, if joins aren't specified on a relationship, we will try to infer them from the foreign key constraints.

Instance Variables:
	name	<Object>	The name of the constraint.
	shouldCreateInDatabase	<Boolean>	We may have table definitions that we don't want to create in the database, either because we know they're already there, or because they are for "imaginary" tables.
	sourceFields	<(SequenceableCollection of: DatabaseField)>	The fields we constrain from. The order is fairly arbitrary, but at least we use it consistently.
	suffixExpression	<String>	A bit of a hack to allow us to append some extra text to the constraint. In particular, added to suppor the ability to append "ON DELETE CASCADE".
	targetFields	<(SequenceableCollection of: DatabaseField)>	The fields we constraint to.

