tests
testModifyAgents
	| agents |
	agents := session read: GlorpTravelAgent orderBy: #id.
	session modify: agents in: [
		agents first name: 'Something Else'.
		(agents at: 2) name: 'something else again'].
	session reset.
	agents := session read: GlorpTravelAgent orderBy: #id.
	self assert: agents size = 3.
	self assert: agents first agency yourSelf = (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf == (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf = agents last agency yourSelf.
	self assert: agents first name = 'Something Else'.
	self assert: (agents at: 2) name = 'something else again'.