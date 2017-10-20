*Glorp
glorpPostFetchValidate: aSession
	"This allows us to do post-read notification of the objects. Note that if this method explicitly returns a false, then we will treat that as meaning that the object is invalid and should not be read. Yes, this is kind of a hack."