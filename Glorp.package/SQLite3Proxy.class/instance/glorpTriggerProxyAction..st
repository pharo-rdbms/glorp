proxy actions
glorpTriggerProxyAction: target
	"Evaluate our action with the owner and the newly retrieved target.
	Return the result of this evaluation, or self if there is no action.
	Since the return value has ambiguous semantics, this needs work."

	| owner block |
	action isNil ifTrue: [^self].
	owner := action key.
	block := action value.
	^block value: owner value: target