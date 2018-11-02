workflow "New workflow" {
  on = "push"
  resolves = [
    "Deploy to Azure",
    "GitHub Action for npm",
  ]
}

action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  secrets = ["SERVICE_PASS"]
  env = {
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "0b4c1735-303b-4aa9-9164-f1a7175b55ed"
    SERVICE_PRINCIPAL = "http://actions-octodemo"
  }
}

action "GitHub Action for npm" {
  uses = "actions/bin/filter@8738e95"
  args = "echo \"hello world\""
}
