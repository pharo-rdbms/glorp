*Glorp
glorpRegisterCollectionInternalsIn: anObjectTransaction 
	"Explicitly register any internal structures (e.g. a VW identity dictionary's valueArray) with the transaction. Assume we can safely register everything inside the collection reflectively. The obvious exceptions would be dependents and sortblocks. This is a cheat, and for peculiar cases you'll need to override this in the subclass"

	| names |
	names := self class allInstVarNames.
	(1 to: names size) do: 
			[:index | 
			(#('dependents' 'sortBlock') includes: (names at: index)) 
				ifFalse: [anObjectTransaction register: (self instVarAt: index)]]