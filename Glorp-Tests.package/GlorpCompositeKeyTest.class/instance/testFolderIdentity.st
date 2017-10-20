tests- basic reading
testFolderIdentity
	| folders |
	folders := session read: GlorpFolder.
	folders do: [:each | | individualFolders individualFolder otherIndividualFolder|
		individualFolders := session read: GlorpFolder where: [:eachFolder | eachFolder = each].
		self assert: individualFolders size = 1.
		individualFolder := individualFolders first.
		otherIndividualFolder := session readOneOf: GlorpFolder where: [:eachFolder | eachFolder = each].
		self assert: individualFolder == each.
		self assert: otherIndividualFolder == individualFolder].