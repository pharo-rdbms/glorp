tests
testOrderBy
	"We can't use database-level ordering in horizontal inheritance because it does multiple queries. We could, I suppose, sort after the fact, but we don't right now"

	| items query |
	query := Query read: GlorpInventoryItem
				where: [:each | each id <= 4].
	query orderBy: #name.
	self should: [items := session execute: query] raise: Dialect error.