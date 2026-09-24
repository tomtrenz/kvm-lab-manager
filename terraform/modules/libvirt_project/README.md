# libvirt_project

The root module is the executable configuration. This directory is reserved for
downstream composition; checkpoint files are intentionally not Terraform
resources. A caller may wrap the root inputs without putting image bytes or
backend credentials in this repository.
