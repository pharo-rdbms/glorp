running
testRearrangeOrderedCollection

	| folder newFolder |
	folder := GlorpTravelFolder new name: 'Fred'.
	4 to: 1 by: -1 do: [:idx | folder files add: (GlorpTravelFile new name: 'File' , idx printString)].
	session inUnitOfWorkDo: [
		session register: folder.
		folder files: (folder files asSortedCollection asOrderedCollection)].
	session reset.
	newFolder := session readOneOf: GlorpTravelFolder where: [:each | each name = 'Fred'].
	self assert: newFolder files asArray = newFolder files asSortedCollection asArray.
	self assert: newFolder files size = 4.