tests
testReadMultipleObjectsOneToMany
	| query result person addresses |

	query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
	query alsoFetch: [:each | each emailAddresses].
	result := query executeIn: session.
	self assert: result size = 1.
	person := result first.
	addresses := person emailAddresses.
	self deny: addresses isGlorpProxy.
	self assert: addresses size = 2.
	self 
		assert: (addresses first id = id1 or: [addresses last id = id1]).
	self 
		assert: (addresses first id = id2 or: [addresses last id = id2]).
	self assert: addresses first id ~= addresses last id.