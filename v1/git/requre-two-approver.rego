package verify

default allow = false

allow {
  input.required_pull_request_reviews.required_approving_review_count == 2
}

message = msg {
  allow
  msg := "Required approving review count is 2."
}

message = msg {
  not allow
  msg := "Required approving review count is not 2."
}
