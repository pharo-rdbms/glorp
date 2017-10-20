tests
testRefreshItemWithMappedPrimaryKeys
	"Prior to vw8.0, Glorp would DNU if trying to refresh an object whose table's primaryKeys were values mapped to other objects, not directly to its instVars.  The primaryKeys of VIDEO_CREDIT_STATUS are mapped to objects in the instVars of its class GlorpVideoCreditStatus.  The refresh: now uses a base that knows its object's descriptor so no longer DNUs in this test."

	| creditStatus |
	creditStatus := session readOneOf: GlorpVideoCreditStatus.
	session refresh: creditStatus.