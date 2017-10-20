as yet unclassified
testInnerQueries
	"self testInnerQueries"

	| session system query result |
	session := GlorpSession new.
	system := self new.
	system platform: OraclePlatform new.
	session system: system.
	system session: session.
	query := self queryForCustomerStation.
	result := session execute: query.
	^result