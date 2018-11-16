# Deploy to staging workflow
workflow "Deploy to staging" {
  on = "push"
  resolves = ["Deploy to Azure stag"]
}

action "Deploy to Azure stag" {
  needs = [
    "Run tests",
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
  needs = ["Check branch", "Install deps"]
}

action "Install deps" {
  uses = "actions/npm@33871a7"
  args = "install"
}

# End deploy to staging workflow

# Release workflow
workflow "Release" {
  on = "release"
  resolves = [
    "bitoiu/release-notify-action@master",
    "Filters for GitHub Actions-1",
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
    "Filters for GitHub Actions",
    "SvanBoxel/delete-merged-branch@master",
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

action "Filters for GitHub Actions-1" {
  uses = "actions/bin/filter@95c1a3b"
  args = "echo \"hello world\" "
} # End deploy to staging workflow

workflow "Failing CI alarm" {
  on = "status"
  resolves = ["Filters for GitHub Actions-2", "maddox/actions/tree/master/home-assistant"]
}

action "Filters for GitHub Actions-2" {
  uses = "actions/bin/filter@95c1a3b"
  args = "action completed"
}

action "Filters for GitHub Actions-3" {
  uses = "actions/bin/filter@95c1a3b"
  args = "branch master"
}

action "maddox/actions/tree/master/home-assistant" {
  uses = "maddox/actions/home-assistant@master"
  needs = ["Filters for GitHub Actions-3", "Filters for GitHub Actions-2"]
  secrets = ["HASS_HOST", "HASS_TOKEN"]
  env = {
    SERVICE_DATA = "{\n  \"entity_id\": \"light.office\",\n  \"flash\": \"short\"\n}"
    DOMAIN = "light"
    SERVICE = "turn_on"
  }
}
