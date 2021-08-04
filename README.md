# hsdp-task-cuda-test

A Docker image that serves as a skeleton for creating [hsdp_function](https://registry.terraform.io/providers/philips-software/hsdp/latest/docs/resources/function) tasks which can take advantage of HSDP Iron GPU workers.

# Usage

```hcl
module "siderite_backend" {
  source = "philips-labs/siderite-backend/cloudfoundry"

  cf_region   = "eu-west"
  cf_org_name = "hsdp-demo-org"
  cf_user     = var.cf_user
  iron_plan = "large-encrypted-gpu"
}

resource "hsdp_function" "cuda_test" {
  name         = "cuda-test"
  docker_image = "philipslabs/hsdp-task-cuda-test:latest"
  command      = ["/app/cudatest"]

  schedule = "*/5 * * * *"

  backend {
    credentials = module.siderite_backend.credentials
  }
}
```

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel

# License

License is MIT
