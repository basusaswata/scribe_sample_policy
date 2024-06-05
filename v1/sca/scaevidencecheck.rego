
package verify

import future.keywords.in

allow := true {
  input.evidence.predicate.environment.file_path == "alice"
}
