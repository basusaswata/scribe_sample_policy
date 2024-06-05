package verify
import rego.v1
import future.keywords.if

allow := true {
  input.evidence.predicate.environment.file_path == "alice"
}
