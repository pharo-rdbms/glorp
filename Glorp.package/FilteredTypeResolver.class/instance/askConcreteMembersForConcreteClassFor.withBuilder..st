type resolving
askConcreteMembersForConcreteClassFor: row withBuilder: builder
	concreteMembers do: [:each |
		each describedConcreteClassFor: row withBuilder: builder]