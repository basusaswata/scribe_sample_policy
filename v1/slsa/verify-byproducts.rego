package verify

import future.keywords.in

default allow := false

default violations := []

verify = v {
	v := {
		"allow": allow,
		"violation": {
			"type": "Missing Byproducts",
			"details": violations,
		},
		"summary": [{
			"allow": allow,
			"reason": reason,
			"violations": count(violations),
		}],
	}
}

allow {
	count(violations) == 0
}

reason = v {
	allow
	v := "All required byproducts were created"
}

reason = v {
	not allow
	v := "Not all required byproducts were created"
}

violations = j {
	j := {r |
		some bp in input.config.args.byproducts
		some byproduct in input.evidence.predicate.runDetails.byproducts
		match = byproduct_match(byproduct, bp)
		not match
		r = {"byproduct": bp}
	}
}

byproduct_match(byproduct, bp) {
	contains(byproduct.uri, bp)
}

byproduct_match(byproduct, bp) {
	contains(byproduct.digest[_], bp)
}

byproduct_match(byproduct, bp) {
	contains(byproduct.content, bp)
}
