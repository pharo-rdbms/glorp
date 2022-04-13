Class {
	#name : #BaselineOfGlorp,
	#superclass : #BaselineOf,
	#category : #BaselineOfGlorp
}

{ #category : #baselines }
BaselineOfGlorp >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ spec
				package: 'Glorp';
				group: 'Core' with: 'Glorp';
			
				package: 'Glorp-Unit-Tests' with: [ spec requires: 'Glorp' ];
				group: 'Tests' with: 'Glorp-Unit-Tests';
				group: 'CI' with: 'Glorp-Unit-Tests';
			
				package: 'Glorp-Integration-Tests' with: [ spec requires: 'Glorp-Unit-Tests' ];
				group: 'Tests' with: 'Glorp-Integration-Tests'.	
			
			"This keeps backwards compatibility for people loading Glorp-Tests"
			spec group: 'Glorp-Tests' with: 'Tests'
			].
	spec
		for: #'pharo10.x'
		do: [ spec
				package: 'Glorp-Pharo10';
				group: 'Core' with: 'Glorp-Pharo10'
			]
]

{ #category : #baselines }
BaselineOfGlorp >> projectClass [

	^ MetacelloCypressBaselineProject
]
