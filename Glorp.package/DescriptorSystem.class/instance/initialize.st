initialize-release
initialize
	descriptors := Dictionary new.
	tables := Dictionary new.
	classModels := Dictionary new.
	typeResolvers := Dictionary new.
	sequences := Dictionary new.
	useDirectAccessForMapping := true.
	allClasses := OrderedCollection new