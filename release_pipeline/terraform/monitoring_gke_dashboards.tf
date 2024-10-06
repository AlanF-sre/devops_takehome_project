resource "google_monitoring_dashboard" "cluster_dashboard" {
  dashboard_json = jsonencode({
    "displayName": "${data.terraform_remote_state.saleor_cluster.outputs.cluster_name} Dashboard",
    "mosaicLayout": {
      "columns": 48,
      "tiles": [
        {
          "widget": {
            "title": "Kubernetes Container - CPU usage time",
            "xyChart": {
              "chartOptions": {
                "mode": "COLOR"
              },
              "dataSets": [
                {
                  "minAlignmentPeriod": "60s",
                  "plotType": "LINE",
                  "targetAxis": "Y1",
                  "timeSeriesQuery": {
                    "timeSeriesFilter": {
                      "aggregation": {
                        "alignmentPeriod": "60s",
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"kubernetes.io/container/cpu/core_usage_time\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"${data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name}\""
                    }
                  }
                }
              ],
              "yAxis": {
                "scale": "LINEAR"
              }
            }
          },
          "height": 16,
          "width": 24
        },
        {
          "widget": {
            "title": "Kubernetes Container - Memory usage",
            "xyChart": {
              "chartOptions": {
                "mode": "COLOR"
              },
              "dataSets": [
                {
                  "minAlignmentPeriod": "60s",
                  "plotType": "LINE",
                  "targetAxis": "Y1",
                  "timeSeriesQuery": {
                    "timeSeriesFilter": {
                      "aggregation": {
                        "alignmentPeriod": "60s",
                        "perSeriesAligner": "ALIGN_MEAN"
                      },
                      "filter": "metric.type=\"kubernetes.io/container/memory/used_bytes\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"${data.terraform_remote_state.saleor_cluster.outputs.saleor_namespace_name}\""
                    }
                  }
                }
              ],
              "yAxis": {
                "scale": "LINEAR"
              }
            }
          },
          "height": 16,
          "width": 24,
          "xPos": 24
        },
        {
          "widget": {
            "alertChart": {
              "name": google_monitoring_alert_policy.saleor_cluster_cpu_alert.name
            }
          },
          "height": 16,
          "width": 24,
          "yPos": 16
        },
        {
          "widget": {
            "alertChart": {
              "name": google_monitoring_alert_policy.saleor_cluster_memory_alert.name
            }
          },
          "height": 16,
          "width": 24,
          "xPos": 24,
          "yPos": 16
        },
        {
          "widget": {
            "title": "Kubernetes Container - Error log entries",
            "xyChart": {
              "chartOptions": {
                "mode": "COLOR"
              },
              "dataSets": [
                {
                  "minAlignmentPeriod": "60s",
                  "plotType": "LINE",
                  "targetAxis": "Y1",
                  "timeSeriesQuery": {
                    "timeSeriesFilter": {
                      "aggregation": {
                        "alignmentPeriod": "60s",
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"saleor-namespace\" metric.label.\"log\"=\"stderr\""
                    }
                  }
                }
              ],
              "yAxis": {
                "scale": "LINEAR"
              }
            }
          },
          "height": 16,
          "width": 24,
          "yPos": 32
        }
      ]
    }
  })
}