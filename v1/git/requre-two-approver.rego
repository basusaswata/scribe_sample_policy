package verify

default allow = false

allow {
  input.required_pull_request_reviews.required_approving_review_count == 2
}
