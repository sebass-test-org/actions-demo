workflow "New workflow" {
  on = "push"
  resolves = [
    "Deploy to Azure",
    "GitHub Action for npm",
  ]
}

action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  env = {
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "caf029ea-80db-4a5b-b308-302824f8a0a1"
    SERVICE_PRINCIPAL = "http://azure-action-octodemo"
  }
  secrets = ["SERVICE_PASS"]
}

action "GitHub Action for npm" {
  uses = "actions/bin/filter@8738e95"
  args = "echo \"hello world\""
}
