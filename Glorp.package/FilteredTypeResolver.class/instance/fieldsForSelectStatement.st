type resolving
fieldsForSelectStatement
	"Return fields that are needed in a select statement - i.e. return all inherited fields that are part of the tables we are already selecting for this object, but not in the main descriptor"
	| fields rootFields |
	fields := OrderedCollection new.
	rootFields := self rootDescriptor mappedFields asSet.
	self concreteMembers do: [:each |
		each == self rootDescriptor ifFalse: [
			each mappedFields do: [:eachSubField |
				(rootFields includes: eachSubField) ifFalse: [
					fields add: eachSubField]]]].
	^fields