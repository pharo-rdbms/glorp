*Glorp
queryAll
	"Return a query object that will query the database for all objects of this class. If you want to just return the object, use find: instead. The advantage of this is that you can use this to get a basic query, but then modify it before executing it."
	"Person queryAll"
	^Query read: self.