accessing
reverseJoin: aJoin
	"Set the reverse join - the join from the link table to the target table. Normally this will be calculated based on the foreign key constraints, but in rare cases (e.g. a foreign key that may be to more than one table) you may want to set it explicitly"

	reverseJoin := aJoin.