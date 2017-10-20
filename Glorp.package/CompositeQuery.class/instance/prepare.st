preparing
prepare
	queries do: [:each | each session: session].
	queries do: [:each | each prepare].