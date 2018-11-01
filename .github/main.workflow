workflow "New workflow" {
  on = "push"
  resolves = ["Deploy to Azure"]
}

action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  secrets = ["SERVICE_PASS"]
  env = {
    SERVICE_PRINCIPAL = "octodemo-action"
    TENANT_ID = "daebfcd0-e8cd-4370-af52-cb35ef2de5da"
    APPID = "0ce87c80-4f4b-4957-8796-8872da7996a1"
  }
}
