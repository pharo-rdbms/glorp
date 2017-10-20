proxy actions
glorpTriggerProxyAction: target
	"Evaluate our action with the owner and the newly retrieved target."
	| owner block |
	action isNil ifTrue: [^self].
	owner := action key.
	block := action value.
	block value: owner value: target