bound values
singleRowBoundFields
	"Note: We will actually have to bind one more thing than this, the optimistic lock fields (if present). That's handled in the caller"
	| basicFields |
	basicFields := self fieldsNeedingUpdate.
	^basicFields , row table primaryKeyFields asArray