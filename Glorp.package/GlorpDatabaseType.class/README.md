This is an abstract superclass for objects representing types in the database. Each one will correspond to a particular simple type that we can store and retrieve from the database. e.g. int, varchar, and so on. For types that are variable sizes, different instances may represent, e.g. varchar(5) vs. varchar(20). While the classes may be reused across different databases, a database platform is expected to be able to return the types that it knows about as instances of these clasess. So you can send #varchar to OraclePlatform and get back one of these.

Subclasses must implement the following messages:
	exdi specific
		exdiType

Instance Variables
	platform	<DatabasePlatform>	The platform that owns us.
	typeString	<String>	Our name in the database.
	selector <Symbol> The name of the message we can send to the platform to get ourselves or an equivalent type back again.

