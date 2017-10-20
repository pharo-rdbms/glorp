support
writeAgents
	| agent1 agent2 agent3 |
	agent1 := GlorpTravelAgent new id: 1; name: 'Agent One'.
	agent1 agency: (GlorpTravelAgency new name: 'Agency One').
	agent2 := GlorpTravelAgent new id: 2; name: 'Agent Two'.
	agent2 agency: agent1 agency.
	agent3 := GlorpTravelAgent new id: 3; name: 'Agent Three'.
	agent3 agency: (GlorpTravelAgency new name: 'Agency Two').
	session modify: (Array with: agent1 with: agent2 with: agent3) in: [].