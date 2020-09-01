package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVPCExample(t *testing.T) {
	t.Parallel()

	// https://github.com/gruntwork-io/terratest/blob/master/test/terraform_aws_network_example_test.go
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	opts := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/vpc",

		Vars: map[string]interface{}{
			"region":      awsRegion,
			"vpcCidr":     "192.168.0.0/16",
			"environment": "test",
		},
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)
}
