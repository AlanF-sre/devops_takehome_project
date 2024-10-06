resource "google_monitoring_alert_policy" "saleor_cluster_cpu_alert" {
  display_name = "High CPU Usage Alert - ${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}"
  project      = var.gcp_project
  combiner = "OR"

  conditions {
    display_name = "Kubernetes Node - CPU allocatable utilization for ${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}"
    condition_threshold {
      filter = "resource.type = \"k8s_node\" AND resource.labels.cluster_name = \"${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}\" AND metric.type = \"kubernetes.io/node/cpu/allocatable_utilization\""
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      threshold_value = 0.8
      trigger {
        count = 1
      }
    }
  }
  enabled               = true
  notification_channels = []
  severity              = "WARNING"
}

resource "google_monitoring_alert_policy" "saleor_cluster_memory_alert" {
  display_name = "High Memory Usage Alert - ${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}"
  project      = var.gcp_project
  combiner = "OR"

  conditions {
    display_name = "Kubernetes Node - Memory allocatable utilization for ${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}"
    condition_threshold {
      filter = "resource.type = \"k8s_node\" AND resource.labels.cluster_name = \"${data.terraform_remote_state.saleor_cluster.outputs.cluster_name}\" AND metric.type = \"kubernetes.io/node/memory/allocatable_utilization\""
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      threshold_value = 0.8
      trigger {
        count = 1
      }
    }
  }
  enabled               = true
  notification_channels = []
  severity              = "WARNING"
}


resource "google_monitoring_alert_policy" "saleor_dashboard_uptime_alert_policy" {
  display_name = "Saelor Dashboard Failed Uptime Check"
  combiner = "OR"

  conditions {
    display_name = "Uptime Condition"
    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.saleor_dashboard_uptime_check.id}\" AND resource.type=\"k8s_service\""
      comparison = "COMPARISON_GT"
      threshold_value = 0
      duration = "60s"

      aggregations {
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields = [
          "resource.label.*"
        ]
        per_series_aligner  = "ALIGN_NEXT_OLDER"
      }
    }
  }

  enabled               = true
  notification_channels = []
  severity              = "CRITICAL"
}