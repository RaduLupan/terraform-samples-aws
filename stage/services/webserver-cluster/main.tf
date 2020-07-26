provider "aws" {
    version = "2.70.0"
    region  = var.region
}

module "webserver_cluster" {
    source "../../../modules/services/webserver-cluster"
}