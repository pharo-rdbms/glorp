This is a function that is infix. That is, it prints its name in between its arguments. For example, + for string concatenation, || for logical OR. 

Instance Variables:
	arguments	<Collection of GlorpExpression>	Our post-arguments (the first one being the base).
	functionParts <Array of: String> The parts of our name. For a two-argument function, this is just the same as an array containing the name, but for one with more (e.g. BETWEEN AND) it contains the different portions of the name.
