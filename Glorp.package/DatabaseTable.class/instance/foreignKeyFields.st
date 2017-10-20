private/fields
foreignKeyFields
	"Answer the receiver's fields which are part of any foreign key constraints.  (This was called by DatabaseRow>>canUpdateRow:, now discarded as a needless check for a never-naturally-occurring condition, but is left as a utility method.)"

	^self foreignKeyConstraints
		inject: IdentitySet new
		into: [:sum :eachConstraint |
			sum addAll: eachConstraint sourceFields.
			sum]