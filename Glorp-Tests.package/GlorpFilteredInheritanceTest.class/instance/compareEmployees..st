tests
compareEmployees: employees

	employees do: [:each |
		| corresponding |
		corresponding := allEmployees detect: [:eachOriginal | each id = eachOriginal id].
		self assert: corresponding = each].