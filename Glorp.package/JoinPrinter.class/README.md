This is a helper class used for printing collections of joins in the <expletive deleted> ANSI join syntax. This syntax wants us to embed all of the joins into the initial list of tables, so we have to come up with an order for printing that makes sure we get all the joins in properly. This is more complicated than you might think.

Instance Variables:
	availableTables	<(Collection of: DatabaseTable)>	Which are the tables that we plan to print.
	joinsToProcess	<(Collection of: Join)>	Which joins do we have to put in between those tables somehow or other.
	query	<Query>	What is the query in which we are printing all of this.

