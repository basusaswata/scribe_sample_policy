package verify

# Deny rule to collect validation errors
deny[{"msg": msg}] {
    not filename_is_bhuchu
    msg := "action must be 'basusaswata1'"
}

# Helper rule
filename_is_bhuchu {
    input.predicate.environment.actor == "basusaswata1"
}
