instance creation
forRows: aCollection
	"Convenience - construct a row map from a given set of rows"
	| map |
	map := self new.
	aCollection do: [:each | map addRow: each].
	^map