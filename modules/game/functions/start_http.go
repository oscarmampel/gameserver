package restart

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"os"

	compute "cloud.google.com/go/compute/apiv1"
	computepb "cloud.google.com/go/compute/apiv1/computepb"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

func init() {
	functions.HTTP("StartInstanceHTTP", StartInstanceHTTP)
}

func StartInstanceHTTP(w http.ResponseWriter, r *http.Request) {
	envVar := os.Getenv("INSTANCE_NAME")
	if envVar == "" {
		fmt.Fprint(w, "INSTANCE_NAME environment variable not set")
		return
	}
	projectID := os.Getenv("PROJECT_ID")
	if projectID == "" {
		fmt.Fprint(w, "PROJECT_ID environment variable not set")
		return
	}
	zone := os.Getenv("ZONE")
	if zone == "" {
		fmt.Fprint(w, "ZONE environment variable not set")
		return
	}
	err := startInstance(w, projectID, zone, envVar)
	if err != nil {
		fmt.Fprintf(w, "Error starting instance: %v", err)
	}
}

func startInstance(w io.Writer, projectID, zone, instanceName string) error {
	ctx := context.Background()
	instancesClient, err := compute.NewInstancesRESTClient(ctx)
	if err != nil {
		return fmt.Errorf("NewInstancesRESTClient: %w", err)
	}
	defer instancesClient.Close()

	req := &computepb.StartInstanceRequest{
		Project:  projectID,
		Zone:     zone,
		Instance: instanceName,
	}

	op, err := instancesClient.Start(ctx, req)
	if err != nil {
		return fmt.Errorf("unable to start instance: %w", err)
	}

	if err = op.Wait(ctx); err != nil {
		return fmt.Errorf("unable to wait for the operation: %w", err)
	}

	fmt.Fprintf(w, "Instance started\n")

	return nil
}
