# Terraform hranice odpovědnosti

Root module používá `dmacvicar/libvirt` `0.9.9`, `for_each` nad VM i disky a
vytváří pouze directory pool, writable QCOW2 overlaye a libvirt domény.
Immutable checkpointy nejsou Terraform resources, aby destroy/apply nemohly
zničit katalog stavů. Backend se předává při `terraform init` zvenku; nikdy
neukládejte hesla do `.tfvars` ani state image adresáře. `backend.example.hcl`
je pouze dokumentační placeholder a není načítán automaticky.
