package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAlbExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../../../terraform-samples-aws/examples/alb",
	}

	// Clean up everything at the end of the test. Defer ensures that this runs regardless of the exit code of the function.
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)

	// Get the URL of the ALB
	albDNSName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDNSName)

	// Test that the ALB's default action is working and returns a 404
	expectedStatus := 404
	expectedBody := "404: page not found"

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)
}
