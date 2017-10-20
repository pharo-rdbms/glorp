baselines
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec 
			package: 'Glorp';
			package: 'Glorp-Tests' with: [ spec requires: #('Glorp' ) ] ].