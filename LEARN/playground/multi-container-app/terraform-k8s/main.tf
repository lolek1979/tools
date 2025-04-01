provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "backend" {
    metadata {
      name = "backend"
    }
    spec {
      replicas = 1
      selector {
        match_labels = {
          app = "backend"
        }
      }
      template {
        metadata {
          labels = {
            app = "backend"
          }
        }
        spec {
            container {
                image = "multi-container-app-backend:latest"
                name = "backend"
                image_pull_policy = "Never"
                port {
                    container_port = 5000
                }              
            }
        }
      }
    }
}

resource "kubernetes_service" "backend" {
    metadata {
      name = "backend"
    }
    spec {
      selector = {
        app = "backend"
      }
      port {
        port = 5000
        target_port = 5000
      }
    }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          image = "multi-container-app-frontend:latest"
          name = "frontend"
          image_pull_policy = "Never"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
    metadata {
      name = "frontend"
    }
    spec {
      type = "NodePort"
      selector = {
        app = "frontend"
      }
      port {
        port = 80
        target_port = 80
        node_port = 30080
      }
    }
}