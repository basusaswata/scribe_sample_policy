package verify

import future.keywords.in

default allow = false

default branch = "main"

default violations = []

verify = v {
	v := {
		"allow": allow,
		"violation": {
			"type": "Commits to main branch",
			"details": violations,
		},
		"summary": [{
			"allow": allow,
			"reason": reason,
		}],
	}
}

branch = input.predicate.environment.git_branch

allow {
	branch != "main"
	branch != "master"
}

allow {
	not find_commit_to_main
}

reason = v {
	allow
	v := "No disallowed commits to main branch 1"
}

reason = v {
	not allow
	v := "Disallowed commits to main branch were detected 2"
}

find_commit_to_main {
	some component in input.evidence.predicate.bom.components
	component.group == "commit"
}

violations = v {
	not allow
	v := [{
		"branch": branch,
	}]
}
