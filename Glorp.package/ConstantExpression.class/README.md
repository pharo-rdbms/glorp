This represents a literal constant. So, if object field = 2, this would be the (2) part.

Instance Variables:
	alias	<String>	Sometimes in queries we want to retrieve something specific in a column value. So, e.g. "select name as one, 2 as two from ...." Where we get back columns named 'one' and 'two', where the value of 'two' is always 2. The alias tells us what to alias the column for this as, if we're using this as something to be selected.
	value	<Object>	The literal constant value.

