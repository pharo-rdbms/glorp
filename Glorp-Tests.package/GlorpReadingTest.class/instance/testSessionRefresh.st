tests-refreshing
testSessionRefresh
	"Check that we refresh correctly when the refresh flag is set"
	self checkRefreshDoing: [:anAddress | session refresh: anAddress].