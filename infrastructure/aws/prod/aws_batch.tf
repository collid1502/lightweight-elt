// AWS Batch is a service which helps you to run batch computing workloads on the AWS Cloud. 
// Batch computing is a common way for developers, scientists, and engineers to access large 
// amounts of compute resources. AWS Batch removes the undifferentiated heavy lifting of configuring 
// and managing the required infrastructure, similar to traditional batch computing software. This 
// service can efficiently provision resources in response to jobs submitted in order to eliminate 
// capacity constraints, reduce compute costs, and deliver results quickly.

// Using FARGATE
// AWS Fargate launches and scales the compute to closely match the resource requirements that you specify 
// for the container. With Fargate, you don't need to over-provision or pay for additional servers
// The below is essentially a serverless environment for us to run workloads on 
resource "aws_batch_compute_environment" "retail_batch_env" {
  compute_environment_name = "retail-fargate-batch-environment"
  type                     = "MANAGED" # Managed by AWS 

  compute_resources {
    type               = "FARGATE"                               # Specify Fragte rather than EC2 per AWS advice, except in specific use cases
    max_vcpus          = 16                                      # A vCPU is a unit of computational capacity
    subnets            = [aws_subnet.retail_public.id]           # References the subnet created in VPC
    security_group_ids = [aws_security_group.retail_batch_sg.id] # Referencing the SG created in `security_groups` 

    # Optional: For Fargate Spot (for cost savings)
    # type               = "FARGATE_SPOT"
  }
  // max_vcpus parameter sets the upper limit on the total number of vCPUs that the AWS Batch compute 
  // environment can scale up to. It’s a cap on the maximum amount of compute power that the environment 
  // is allowed to use, ensuring that the environment does not consume more resources than you have budgeted 
  // for or designed for your workloads

  // using AWS Fargate, you don't manage the underlying EC2 instances directly; instead, you specify how much 
  // CPU and memory you need for each task. Fargate then provisions the necessary resources automatically. 
  // Setting max_vcpus controls how many total CPU resources across all running tasks are allowed at any one time

  service_role = aws_iam_role.batch_service_role.arn # References the service role created in IAM.tf 
}


// This resource creates an AWS Batch job queue. A job queue is essentially a FIFO (First In, First Out) 
// queue where jobs are submitted and then dispatched to a compute environment for processing based on their 
// priority and availability of resources
resource "aws_batch_job_queue" "retail_job_queue" {
  name = "retail-fargate-job-queue"

  //This attribute specifies one or more compute environments that the job queue is associated with
  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.retail_batch_env.arn
  }

  priority = 1         // This attribute sets the priority of the job queue
  state    = "ENABLED" // This attribute defines the state of the job queue
  // If set to "DISABLED", the job queue will not accept new jobs, and no jobs will be dispatched 
  // from this queue to the compute environments. However, jobs already in the queue can still be 
  // executed unless they are terminated or cancelled
}
