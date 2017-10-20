tests
testOrderBy
	| employees query |
	session beginTransaction.
	
	[session beginUnitOfWork.
	self writeTestHarness.
	session commitUnitOfWork.
	query := Query read: GlorpEmployee
				where: [:each | each id <= 4].
	query orderBy: #name.
	query orderBy: #id.
	employees := session execute: query.
	self assert: (employees asSortedCollection: [:a :b | a name = b name ifTrue: [
		a id <= b id] ifFalse: [a name < b name]]) asArray = employees]
			ensure: [session rollbackTransaction]