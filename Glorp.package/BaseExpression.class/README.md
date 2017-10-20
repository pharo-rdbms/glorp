This represents the base object that we're looking for in a query. So if we ask to read: Person, then we will have a base expression corresponding to Person. Even if what we end up retrieving is not part of the Person object, it remains the base, because it's what defines our point of view.

Instance Variables:
	availableSubSelectNumber	<Integer>	As the base of the query, we keep track of how many subselects there are. New subselects will need to have a unique number so they can prefix their tables as e.g. s1t1 when aliasing them, and the number comes from this counter.
	descriptor	<Descriptor>	The descriptor for the class we're looking for.

