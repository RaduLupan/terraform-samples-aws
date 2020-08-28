package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMySQLExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/mysql",

		Vars: map[string]interface{}{
			// RDS DB name won't allow "-" use "_" instead as a separator.
			"db_name":     fmt.Sprintf("test_%s", random.UniqueId()),
			"db_password": "password",
		},
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)
}
