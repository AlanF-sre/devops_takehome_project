resource "google_monitoring_dashboard" "database_dashboard" {
  dashboard_json = jsonencode({
    "displayName": "Saleor Prod DB Monitoring",
    "mosaicLayout": {
      "columns": 48,
      "tiles": [
        {
          "widget": {
            "title": "Prod DB Disk Utilization",
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
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
            "title": "Prod DB CPU utilization",
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
                        "crossSeriesReducer": "REDUCE_PERCENTILE_95",
                        "groupByFields": [
                          "resource.label.\"database_id\""
                        ],
                        "perSeriesAligner": "ALIGN_MEAN"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
            "title": "Prod DB Memory utilization",
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
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/memory/components\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
          "yPos": 16
        },
        {
          "widget": {
            "title": "Disk I/O Operations",
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
                        "crossSeriesReducer": "REDUCE_SUM",
                        "groupByFields": [
                          "resource.label.\"database_id\""
                        ],
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/disk/read_ops_count\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
                    }
                  }
                },
                {
                  "minAlignmentPeriod": "60s",
                  "plotType": "LINE",
                  "targetAxis": "Y1",
                  "timeSeriesQuery": {
                    "timeSeriesFilter": {
                      "aggregation": {
                        "alignmentPeriod": "60s",
                        "crossSeriesReducer": "REDUCE_SUM",
                        "groupByFields": [
                          "resource.label.\"database_id\""
                        ],
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/disk/write_ops_count\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
          "xPos": 24,
          "yPos": 16
        },
        {
          "widget": {
            "title": "DB Connections",
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
                        "crossSeriesReducer": "REDUCE_SUM",
                        "perSeriesAligner": "ALIGN_MEAN"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
        },
        {
          "widget": {
            "title": "Deadlocks",
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
                        "crossSeriesReducer": "REDUCE_SUM",
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/deadlock_count\" resource.type=\"cloudsql_database\""
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
          "xPos": 24,
          "yPos": 32
        },
        {
          "widget": {
            "title": "Log Entries",
            "xyChart": {
              "chartOptions": {
                "mode": "COLOR"
              },
              "dataSets": [
                {
                  "minAlignmentPeriod": "60s",
                  "plotType": "STACKED_BAR",
                  "targetAxis": "Y1",
                  "timeSeriesQuery": {
                    "timeSeriesFilter": {
                      "aggregation": {
                        "alignmentPeriod": "60s",
                        "crossSeriesReducer": "REDUCE_SUM",
                        "groupByFields": [
                          "metric.label.\"severity\""
                        ],
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
          "yPos": 48
        },
        {
          "widget": {
            "title": "Transactions",
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
                        "crossSeriesReducer": "REDUCE_SUM",
                        "perSeriesAligner": "ALIGN_RATE"
                      },
                      "filter": "metric.type=\"cloudsql.googleapis.com/database/postgresql/transaction_count\" resource.type=\"cloudsql_database\" resource.label.\"database_id\"=\"${var.gcp_project}:${data.terraform_remote_state.saleor_cluster.outputs.db_instance_name}\""
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
          "xPos": 24,
          "yPos": 48
        }
      ]
    }
  })
}

