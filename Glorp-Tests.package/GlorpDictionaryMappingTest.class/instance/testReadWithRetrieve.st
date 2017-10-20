tests
testReadWithRetrieve
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	query retrieve: [:each | each].
	query retrieve: [:each | each entries asOuterJoin].
	readBackEncyclopedias := session execute: query.
	session accessor denyReads.
	self assert: readBackEncyclopedias size = 6.
	self verifyEncyclopedias: ((readBackEncyclopedias collect: [:each | each first]) asSet asSortedCollection: [:a :b | a name <= b name]).
	readBackEncyclopedias do: [:eachArray |
		eachArray last key isNil 
			ifTrue: [self assert: eachArray first entries isEmpty]
			ifFalse: [self assert: (eachArray first entries at: eachArray last key) = eachArray last value]].