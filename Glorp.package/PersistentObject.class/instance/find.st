finding objects
find
	"This is a query by example facility. We take whichever fields are filled in the object and read back any objects in the database that match."
	
	| instances |
	instances := GlorpVirtualCollection on: self class in: self session.
	self descriptor mappings do: [:eachMapping | 
		instances := self findMapping: eachMapping in: instances].
	^instances.