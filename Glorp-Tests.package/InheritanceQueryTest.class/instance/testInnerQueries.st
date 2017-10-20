running
testInnerQueries
	| query |
	query := self queryForCustomerStation.
	session execute: query.