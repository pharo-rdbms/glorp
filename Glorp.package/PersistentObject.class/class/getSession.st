*Glorp
getSession
	"Return the session to be used for the current query. In general, we don't know how to find our session. Callers can catch the CannotFindSession exception and resume it, or subclasses can implement this method to find the session using mechanisms like process environment, a global, or whatever else they have available."
	^CannotFindSession raise.