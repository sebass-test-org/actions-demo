# Deploy to staging workflow
workflow "Deploy" {
  on = "push"
  resolves = [
    "Deploy to Azure stag",
    "GitHub Action for Zeit",
  ]
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
    "nexmo-community/nexmo-sms-action",
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

# End deploy to staging workflow

workflow "Failing CI alarm" {
  on = "status"
  resolves = ["maddox/actions/tree/master/home-assistant"]
}

action "Check for master branch" {
  uses = "actions/bin/filter@95c1a3b"
  args = "branch master"
}

action "Is failing" {
  uses = "helaili/github-graphql-action@f9197781e4fe192857ae3a20eb7b028b78097d38"
  runs = ["sh", "-c"]
  args = ["jq -r '.state?' $GITHUB_EVENT_PATH | grep -q failure"]
}

action "maddox/actions/tree/master/home-assistant" {
  uses = "maddox/actions/home-assistant@master"
  needs = [
    "Is failing",
    "Check for master branch",
  ]
  secrets = ["HASS_HOST", "HASS_TOKEN"]
  env = {
    SERVICE_DATA = "{\n  \"entity_id\": \"light.office\",\n  \"flash\": \"short\"\n}"
    DOMAIN = "light"
    SERVICE = "turn_on"
  }
}

action "nexmo-community/nexmo-sms-action" {
  uses = "nexmo-community/nexmo-sms-action@master"
  secrets = [
    "NEXMO_API_KEY",
    "NEXMO_API_SECRET",
    "NEXMO_NUMBER",
  ]
  args = "+31614432016 New release on $GITHUB_REPOSITORY from $GITHUB_ACTOR."
}

workflow "Welcome member" {
  on = "member"
  resolves = [
    "JasonEtco/create-an-issue@master",
  ]
}

action "JasonEtco/create-an-issue@master" {
  uses = "JasonEtco/create-an-issue@master"
  args = "github/welcome.md"
  secrets = ["GITHUB_TOKEN"]
}

workflow "Issue Checklist Checker " {
  resolves = ["CheckChecklist"]
  on = "issues"
}

action "CheckChecklist" {
  uses = "waffleio/gh-actions/action-checklistchecker@master"
  secrets = ["GITHUB_TOKEN"]
}

action "GitHub Action for Zeit" {
  uses = "actions/zeit-now@666edee2f3632660e9829cb6801ee5b7d47b303d"
  needs = ["Run tests"]
  secrets = ["ZEIT_TOKEN"]
  args = "--public "

  # End deploy to staging workflow

  # End release workflow

  # End deploy to staging workflow
} # End deploy to staging workflow

# End release workflow
# End deploy to staging workflow
# End deploy to staging workflow
# End release workflow
# End deploy to staging workflow
# End deploy to staging workflow
# End release workflow
# End deploy to staging workflow
# End deploy to staging workflow
# End release workflow
# End deploy to staging workflow
# End deploy to staging workflow
# End release workflow
# End deploy to staging workflow
