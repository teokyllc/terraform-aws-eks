variable "tags" {
  type    = map
  default = null
}

###############################
###   EKS vars              ###
###############################
variable "create_eks_cluster" {
    type        = bool
    description = "Creates an EKS cluster with a node pool."
    default     = false
}

variable "eks_cluster_role_name" {
    type        = string
    description = "IAM role name that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf."
    default     = null
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9-_]+$)."
  default     = null
}

variable "eks_version" {
  type        = string
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS."
  default     = null
}

variable "enable_private_access" {
  type        = bool
  description = "Whether the Amazon EKS private API server endpoint is enabled."
  default     = true
}

variable "enable_public_access" {
  type        = bool
  description = "Whether the Amazon EKS public API server endpoint is enabled."
  default     = false
}

variable "public_access_cidrs" {
  type        = list(any)
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  default     = null
}

variable "service_ipv4_cidr" {
  type        = string
  description = "The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks."
  default     = null
}

variable "enable_eks_control_plane_logging" {
  type        = bool
  description = "Enables a Cloud Watch Log Group for EKS cluster logging."
  default     = false
}

variable "eks_control_plane_logging_retention_in_days" {
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, 3653, and 0."
  default     = null
}

variable "cluster_log_types" {
  type        = list(any)
  description = "List of the desired control plane logging to enable.  Possible values are: api, audit, authenticator, controllerManager, scheduler."
  default     = null
}

variable "additional_security_groups" {
  type        = list(any)
  description = "List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."
  default     = null
}

variable "eks_node_groups" {
  type        = map
  description = "Creates an EKS node groups."
  default     = null
}


###############################
###   Data vars             ###
###############################
variable "vpc_id" {
  type        = string
  description = "The ID of an AWS VPC."
  default     = null
}

variable "eks_subnet_tier" {
  type        = string
  description = "Subnet tier tag, the subnets in your VPC where the control plane may place elastic network interfaces (ENIs) to facilitate communication with your cluster."
  default     = "private"
}
