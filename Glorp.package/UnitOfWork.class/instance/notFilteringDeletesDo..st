private
notFilteringDeletesDo: aBlock
	"Execute aBlock, with filtering of deletes turned off. This is useful if we are in the process of deleting an object. Suppose we are deleting an object that has a link table relationship, but we have already deleted one of the linked objects. We need to make sure we also delete the link table entry, which means we need to know about that linked object, so we don't want Glorp filtering it out for us."

	| oldCommitPhase |
	[oldCommitPhase := commitPhase.
	commitPhase := #registering.
	aBlock value] ensure: [commitPhase := oldCommitPhase]