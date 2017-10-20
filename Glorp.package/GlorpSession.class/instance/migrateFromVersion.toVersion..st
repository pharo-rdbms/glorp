table creation
migrateFromVersion: fromVersionNumber toVersion: toVersionNumber 
	self halt.
	"Get the class name of our system, strip off version number, replace with to and from, create systems for them."