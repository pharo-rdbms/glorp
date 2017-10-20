tests
testModifyAgentsReadOnlyAgency
	"Test that if the agency mappings are all read-only, that we don't cause an error by trying to generate entries in the row map for its primary keys."

	(session system descriptorFor: GlorpTravelAgency) mappings do: [:each | each beReadOnly].
	[self testModifyAgents] ensure: [
		(session system descriptorFor: GlorpTravelAgency) mappings do: [:each | each readOnly: false]].