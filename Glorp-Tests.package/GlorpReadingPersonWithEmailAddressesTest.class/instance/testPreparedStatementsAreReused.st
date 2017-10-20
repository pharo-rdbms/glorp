tests
testPreparedStatementsAreReused
	"The tearDown ensures our forcing of reusePreparedStatements is reverted."
 
	session useBinding ifFalse: [^self].	"test only makes sense if binding is on"
	
	"20160531, pierce: Skip this test for now."	
	session accessor currentLogin database isUDBCSQLite3Platform ifTrue: [ ^ self ].
	
	oldReuseState := session reusePreparedStatements.
	session reusePreparedStatements: true.
	session reset.
	session read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
	session read: GlorpPerson where: [:eachPerson | eachPerson id ~= 3].
	session read: GlorpPerson where: [:eachPerson | eachPerson id >= 3].
	self assert: session accessor numberOfPreparedStatements = 3.
	session reset.
	1 to: 3 do: [:i | | query |
			query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = (eachPerson parameter: 1)].
			query executeWithParameters: (Array with: i) in: session].
	self assert: session accessor numberOfPreparedStatements = 1.