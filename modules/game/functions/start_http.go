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
	instance_name := os.Getenv("INSTANCE_NAME")
	if instance_name == "" {
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
	hostname := os.Getenv("DUCK_DNS")
	err := startInstance(w, projectID, zone, instance_name, hostname)
	if err != nil {
		fmt.Fprintf(w, "Error starting instance: %v", err)
	}
}

func startInstance(w io.Writer, projectID, zone, instanceName, hostname string) error {
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

	// Obtener la información de la instancia después de iniciarla
	instance, err := instancesClient.Get(ctx, &computepb.GetInstanceRequest{
		Project:  projectID,
		Zone:     zone,
		Instance: instanceName,
	})
	if err != nil {
		return fmt.Errorf("unable to get instance: %w", err)
	}

	// Obtener la IP de la instancia
	var ip string
	for _, networkInterface := range instance.NetworkInterfaces {
		if len(networkInterface.AccessConfigs) > 0 {
			ip = *networkInterface.AccessConfigs[0].NatIP
			break
		}
	}

	if ip == "" {
		return fmt.Errorf("no IP address found for instance")
	}

	fmt.Fprintf(w, "Instance started\nhostname: %s\nIP: %s", hostname, ip)

	return nil
}
