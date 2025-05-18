
locals {
  buckets = {
    for svc in var.services : svc => {
      name-1 = "${var.prefix-1}-logs-${svc}-test"
      name-2 = "${var.prefix-2}-logs-${svc}-test"
      tag  = svc
    }
  }
}


