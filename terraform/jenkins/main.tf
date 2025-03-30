provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create a namespace for Jenkins
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

# Create a PersistentVolumeClaim for Jenkins data
resource "kubernetes_persistent_volume_claim" "jenkins_pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

# Deploy Jenkins using a Deployment
resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = {
      app = "jenkins"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:lts"
          port {
            container_port = 8080
          }
          # Mount the PVC to persist Jenkins data
          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }
        volume {
          name = "jenkins-home"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# Expose Jenkins via a NodePort Service
resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins-service"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  spec {
    selector = {
      app = "jenkins"
    }
    type = "NodePort"
    port {
      port        = 8080
      target_port = 8080
      # Optional: Specify a NodePort, or let Kubernetes assign one automatically.
      node_port   = 32000
    }
  }
}