api
adjustForMementos: objects
	"We may be being passed row map keys that refer to originals when they should refer to mementos. Fix.This is horribly ugly."

	1 to: objects size do: [:i | | possibleRowMapKey |
		possibleRowMapKey := objects at: i.
		(self isRowMapKey: possibleRowMapKey) ifTrue: [
			objects at: i put: (possibleRowMapKey adjustIn: correspondenceMap)]].
	^objects