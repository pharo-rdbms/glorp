tests
testReadAgents
	| agents |
	agents := session read: GlorpTravelAgent orderBy: #id.
	self assert: agents size = 3.
	self assert: agents first agency yourSelf = (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf == (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf = agents last agency yourSelf.