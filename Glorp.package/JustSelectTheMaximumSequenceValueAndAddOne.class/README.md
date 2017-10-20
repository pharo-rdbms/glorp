This is a sequence that just does a select max(primaryKeyFieldName) for the table in question and adds one to it. This is, um, less-than-perfectly efficient, and I'm not at all clear that it'll work for a multi-user system. But it's what Store used to do on SQL Server, so we'd like to be able to mimic it. And it's actually easier to preallocate for than identity columns, which is nice. This isn't really named in the same sense as the others, but it's useful to inherit the named preallocation behaviour, and we store the field to select against in the name.

Instance Variables:
	tableName	<DatabaseTable>	the table we sequence.
	field <DatabaseField> the field we sequence.