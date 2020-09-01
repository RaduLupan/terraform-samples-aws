package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVPCExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/vpc",

		Vars: map[string]interface{}{
			// RDS DB name won't allow "-" use "_" instead as a separator.
			"region":      "us-west-2",
			"vpcCidr":     "192.168.0.0/16",
			"environment": "test",
		},
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)
}
