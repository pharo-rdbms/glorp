running
testDeleteFromAndAddToOrderedCollection

	| folderFromDB final |
	folderFromDB := session readOneOf: GlorpTravelFolder.
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		1 to: 4 do: [:idx | folderFromDB files add: (GlorpTravelFile new name: 'File' , idx printString)]].
	session inUnitOfWorkDo:
		[session register: folderFromDB.
		folderFromDB files remove: (folderFromDB files detect: [:each | each name = 'File3']).
		folderFromDB files add: (GlorpTravelFile new name: 'A New File').
		folderFromDB files add: (GlorpTravelFile new name: 'Another New File').
		].
	final := (session refresh: folderFromDB) files.
	self assert: final size = 5.
	self assert: (final collect: #name) asSortedCollection asArray = #('A New File' 'Another New File' 'File1' 'File2' 'File4').