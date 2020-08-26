package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAsgExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/asg",
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)
}
