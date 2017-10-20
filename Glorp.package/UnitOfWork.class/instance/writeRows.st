private/mapping
writeRows

	succeeded := true.
	self reserveSequenceNumbers.
	self assignSequenceNumbers.
	self session tablesInCommitOrder do: [:eachTable | self writeRowsForTable: eachTable].
	deletePlan reverseDo: [:eachRow | | rowSucceeded |
		rowSucceeded := session writeRow: eachRow.
		succeeded := succeeded & rowSucceeded].
	self readBackNewRowInformation