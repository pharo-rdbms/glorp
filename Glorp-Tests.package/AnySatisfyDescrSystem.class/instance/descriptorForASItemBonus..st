accessing
descriptorForASItemBonus: aDescriptor
	| table newMapping join |
	table := self tableNamed: 'ASITEMBONUS'.
	aDescriptor table: table.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #item.
	join := Join new.
	join
		from: (table fieldNamed: 'ITEMID')
		to: ((self tableNamed: 'ASITEM') fieldNamed: 'ID').
	newMapping join: join.

	newMapping := aDescriptor newMapping: OneToOneMapping.
	newMapping attributeName: #bonus.
	join := Join new.
	join
		from: (table fieldNamed: 'BONUSID')
		to: ((self tableNamed: 'ASBONUS') fieldNamed: 'ID').
	newMapping join: join.