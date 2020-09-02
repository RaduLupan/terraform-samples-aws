package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVPCExample(t *testing.T) {
	t.Parallel()

	// https://github.com/gruntwork-io/terratest/blob/master/test/terraform_aws_network_example_test.go
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/vpc",

		Vars: map[string]interface{}{
			"region":      awsRegion,
			"vpcCidr":     "192.168.0.0/16",
			"environment": "test",
		},
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the example.
	terraform.InitAndApply(t, terraformOptions)

	// Run terraform output to get the value of an output variable.
	publicSubnetID := terraform.Output(t, terraformOptions, "public_subnet_id")
	privateSubnetID := terraform.Output(t, terraformOptions, "private_subnet_id")

	// aws.IsPublicSubnet function verifies that a subnet belongs to a route table with a rule that has an Internet Gateway "igw-" as target.

	// Verify if the subnet that is supposed to be public is really public.
	assert.True(t, aws.IsPublicSubnet(t, publicSubnetID, awsRegion))

	// Verify if the subnet that is supposed to be private is really private.
	assert.False(t, aws.IsPublicSubnet(t, privateSubnetID, awsRegion))
}
