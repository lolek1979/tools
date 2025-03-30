provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create a namespace for GitLab
resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = "gitlab"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Deploy GitLab using the official Helm chart
resource "helm_release" "gitlab" {
  name       = "gitlab"
  namespace  = kubernetes_namespace.gitlab.metadata[0].name
  repository = "https://charts.gitlab.io"
  chart      = "gitlab"
  version    = "6.3.0"  # Replace with the desired chart version
  timeout = 600
  values = [
    file("gitlab-values.yaml"),
    <<EOF
certmanager-issuer:
  email: "p.konieczny@hotmail.com"
EOF
  ]
}