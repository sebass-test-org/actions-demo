workflow "Deploy to staging" {
  on = "push"
  resolves = [
    "Master",
    "bitoiu/release-notify-action@master",
  ]
}

# Filter for master branch
action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Deploy to Azure stag" {
  needs = "Master"
  uses = "./.github/azdeploy"
  env = {
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "caf029ea-80db-4a5b-b308-302824f8a0a1"
    SERVICE_PRINCIPAL = "http://azure-action-octodemo"
  }
  secrets = ["SERVICE_PASS"]
}

action "bitoiu/release-notify-action@master" {
  uses = "bitoiu/release-notify-action@master"
  needs = ["Deploy to Azure stag"]
  secrets = ["RECIPIENTS", "SENDGRID_API_TOKEN"]
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
