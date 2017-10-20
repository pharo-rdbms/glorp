accessing
targetTableJoin: aJoin
	"Set the join from the source table to the target table. Note that is is only required if you are using a link table, and in addition to the link table join need to connect from the source table directly to the target table as well.  This is *NOT* supposed to be a join from the link table to the target table. That's reverseJoin, and is calculated automatically. See relevantLinkTableFields if you need to give a hint, or linkTableJoin: if you want to set it explicitly."
	targetTableJoin := aJoin.
	aJoin owningMapping: self.