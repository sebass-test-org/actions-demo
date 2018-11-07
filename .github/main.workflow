# Deploy to staging workflow
workflow "Deploy to staging" {
  on = "push"
  resolves = ["Deploy to Azure stag"]
}

action "Deploy to Azure stag" {
  needs = [
    "Run tests",
    "Install deps",
  ]
  uses = "./.github/azdeploy"
  env = {
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "caf029ea-80db-4a5b-b308-302824f8a0a1"
    SERVICE_PRINCIPAL = "http://azure-action-octodemo"
  }
  secrets = [
    "SERVICE_PASS",
    "GITHUB_TOKEN",
  ]
}

# Filter for master branch
action "Check branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Run tests" {
  uses = "actions/npm@33871a7"
  args = "test"
  needs = ["Check branch"]
}

action "Install deps" {
  uses = "actions/npm@33871a7"
  needs = ["Check branch"]
  args = "install"
}

# End deploy to staging workflow

# Release workflow
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

# End release workflow

# Delete merged branch workflow
workflow "delete merged branch" {
  on = "pull_request"
  resolves = [
    "SvanBoxel/delete-merged-branch@master",
    "Filters for GitHub Actions",
  ]
}

action "SvanBoxel/delete-merged-branch@master" {
  needs = "Filters for GitHub Actions"
  uses = "SvanBoxel/delete-merged-branch@master"
  secrets = ["GITHUB_TOKEN"]
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@95c1a3b"
  args = "action closed"
}

# End elete merged branch workflow
