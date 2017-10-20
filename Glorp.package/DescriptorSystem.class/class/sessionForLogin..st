instance creation
sessionForLogin: aGlorpLogin
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."
	| system session |
	system := self forPlatform: aGlorpLogin database.
	session := GlorpSession new.
	session accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	session system: system.
	^session