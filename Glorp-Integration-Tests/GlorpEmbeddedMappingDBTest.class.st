"
This exercises the EmbeddedValueOneToOneMapping.
"
Class {
	#name : #GlorpEmbeddedMappingDBTest,
	#superclass : #GlorpMappingDBTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpEmbeddedMappingDBTest >> setUp [
	super setUp.
	session beginTransaction.
	self writeAgents.
	session reset.
]

{ #category : #support }
GlorpEmbeddedMappingDBTest >> tearDown [
	session rollbackTransaction.
	super tearDown.
]

{ #category : #tests }
GlorpEmbeddedMappingDBTest >> testModifyAgents [
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
]

{ #category : #tests }
GlorpEmbeddedMappingDBTest >> testModifyAgentsReadOnlyAgency [
	"Test that if the agency mappings are all read-only, that we don't cause an error by trying to generate entries in the row map for its primary keys."

	(session system descriptorFor: GlorpTravelAgency) mappings do: [:each | each beReadOnly].
	[self testModifyAgents] ensure: [
		(session system descriptorFor: GlorpTravelAgency) mappings do: [:each | each readOnly: false]].
]

{ #category : #tests }
GlorpEmbeddedMappingDBTest >> testReadAgents [
	| agents |
	agents := session read: GlorpTravelAgent orderBy: #id.
	self assert: agents size = 3.
	self assert: agents first agency yourSelf = (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf == (agents at: 2) agency yourSelf.
	self deny: agents first agency yourSelf = agents last agency yourSelf.
]

{ #category : #support }
GlorpEmbeddedMappingDBTest >> writeAgents [
	| agent1 agent2 agent3 |
	agent1 := GlorpTravelAgent new id: 1; name: 'Agent One'.
	agent1 agency: (GlorpTravelAgency new name: 'Agency One').
	agent2 := GlorpTravelAgent new id: 2; name: 'Agent Two'.
	agent2 agency: agent1 agency.
	agent3 := GlorpTravelAgent new id: 3; name: 'Agent Three'.
	agent3 agency: (GlorpTravelAgency new name: 'Agency Two').
	session modify: (Array with: agent1 with: agent2 with: agent3) in: [].
]
