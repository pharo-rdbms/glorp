This is a specialized variety of expression that is more constrained and is used for defining relationships. It has two main purposes
 - ease of construction: Relationships are normally defined by field to field equality expressions (my foreign key field = his primary key field). These are more tedious to create via block expressions, so this provides a simpler syntax.
 - constrained semantics. These define both read and write for the relationship, so fully general expressions won't work (most notably, relations other than equality are hard to write). Using a primaryKeyExpression ensures that we satisfy these constraints.

I'm not completely sure this class is a good idea. It makes for an annoying assymetry between different kinds of expressions. This is especially notable now that we allow sources to be constants. It's possible that all we need is an expression constructor that generates real expressions, but with more convenient syntax and ensuring that the constraints are met.

Note that although these are typically fk=pk, it's allowed to be the other way around -- i.e. our object-level relationships can be the opposite of the way the fk's "point" in the database.

Instance Variables:
	base	<BaseExpression>	The base on which we are built. Mostly used if we want to convert this into a real expression.
	sources	<SequenceableCollection of: (DatabaseField | ConstantExpression)> The source fields (typically the foreign keys)
	targets	<SequenceableCollection of: DatabaseField> The target fields (typically the targets of the foreign keys)

