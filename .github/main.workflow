workflow "Deploy to staging" {
  on = "push"
  resolves = [
    "Master",
    "Deploy to Azure stag",
    "actions/npm@master",
  ]
}

# Filter for master branch
action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Deploy to Azure stag" {
  needs = ["Master", "actions/npm@master"]
  uses = "./.github/azdeploy"
  env = {
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "caf029ea-80db-4a5b-b308-302824f8a0a1"
    SERVICE_PRINCIPAL = "http://azure-action-octodemo"
  }
  secrets = ["SERVICE_PASS"]
}

workflow "Release" {
  on = "release"
  resolves = [
    "bitoiu/release-notify-action@master",
  ]
}

action "bitoiu/release-notify-action@master" {
  uses = "bitoiu/release-notify-action@master"
  secrets = [
    "SENDGRID_API_TOKEN",
    "RECIPIENTS",
  ]
}

action "GitHub Action for npm" {
  uses = "actions/npm@master"
  args = "install"
}

action "actions/npm@master" {
  uses = "actions/npm@master"
  needs = ["GitHub Action for npm"]
  args = "test"
}

workflow "delete merged branch" {
  on = "pull_request"
  resolves = ["SvanBoxel/delete-merged-branch@e5495dec3189af9c871c9c8588066a73a2dd4a85"]
}

action "SvanBoxel/delete-merged-branch@e5495dec3189af9c871c9c8588066a73a2dd4a85" {
  uses = "SvanBoxel/delete-merged-branch@docker-actions"
  secrets = ["GITHUB_TOKEN"]
} # workflow "Deploy to production" {

#   on = "release"
#   resolves = [
#     "Deploy to Azure prod",
#   ]
# }
# action "Deploy to Azure prod" {
#   uses = "./.github/azdeploy"
#   env = {
#     TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
#     APPID = "99c953c7-8726-4767-9d76-aeece4663224"
#     SERVICE_PRINCIPAL = "http://azure-action-octodemo-prod"
#   }
#   secrets = ["SERVICE_PASS"]
# }
