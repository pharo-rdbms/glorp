tests
testPreparedStatementsAreFaster
	"Not really a good test, since there are lots of other factors. And since we don't support this on all dialects/databases, they might easily be the same. Maybe should remove this test, but on the other hand it's the most useful feedback that the prepared statements are actually good for something.  (The tearDown ensures our forcing of reusePreparedStatements is reverted.)"

	| timePrepared timeUnPrepared |
	oldReuseState := session reusePreparedStatements.
	session reusePreparedStatements: true.
	session reset.
	timeUnPrepared := Time millisecondsToRun: [
		session read: GlorpPerson where: [:eachPerson | eachPerson id = 3].
		session read: GlorpPerson where: [:eachPerson | eachPerson id ~= 3].
		session read: GlorpPerson where: [:eachPerson | eachPerson id >= 3]].
	session reset.
	timePrepared := Time millisecondsToRun: [
		3 timesRepeat: [ | query |
			query := Query read: GlorpPerson where: [:eachPerson | eachPerson id = (eachPerson parameter: 1)].
			query executeWithParameters: #(3) in: session]].
	(session accessor numberOfPreparedStatements < 1) ifTrue: [^self "Unsupported, don't bother testing"].
	Transcript cr; show: 'Time reusing prepared statements = ', timePrepared printString.
	Transcript cr; show: 'Time not reusing prepared statements = ', timeUnPrepared printString.
	"Give a little bit of room, so if they take roughly the same amount of time it'll still pass"
	self assert: (timePrepared * 0.8 )< timeUnPrepared.