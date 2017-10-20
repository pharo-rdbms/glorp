*Glorp
glorpAddAllToDictionary: aDictionary
	"Assumes that we are a collection of associations"
	self do: [:each | aDictionary add: each].