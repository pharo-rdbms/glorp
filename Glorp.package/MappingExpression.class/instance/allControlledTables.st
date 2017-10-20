preparing
allControlledTables
	"Return all the tables that we control, directly or indirectly. Basically, if we are a mapping expression with a link table, return the link table as well as any tables of ours."
	| all join |
	self controlsTables ifFalse: [^#()].
	all := Set new.
	all addAll: self tables.
	mapping := self mapping.
	mapping isNil 
		ifFalse: [
			join := mapping join.
			join isNil ifFalse: [all addAll: join allControlledTables]].
	^all.