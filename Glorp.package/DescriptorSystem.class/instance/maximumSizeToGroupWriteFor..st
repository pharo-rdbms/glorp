optimization parameters
maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows
	"If we are going to group write, how many rows of this collection should we do it for at once. Normally we delegate this to the platform, but we allow the system to intervene if desired"
	^platform maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows