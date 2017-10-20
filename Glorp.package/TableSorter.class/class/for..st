instance creation
for: tables

	| sorter |
	sorter := self new.
	tables do: [:each |
		sorter addTable: each].
	^sorter