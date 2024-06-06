package verify

# Deny rule to collect validation errors
deny[{"msg": msg}] {
    not id_is_valid
    msg := "ID must be a number"
}

# Helper rule
id_is_valid {
    input.id
    input.id == number
}
