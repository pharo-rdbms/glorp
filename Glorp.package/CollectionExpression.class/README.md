This represents expressions on collection objects taking a block, which at the moment means just anySatisfy:

We treat this as a relation, but with the special properties that when we convert the right hand side into an expression we assume it's a block and give it a base which is the left-hand side. Also, we don't print this relation when printing SQL, we just print the right hand side.