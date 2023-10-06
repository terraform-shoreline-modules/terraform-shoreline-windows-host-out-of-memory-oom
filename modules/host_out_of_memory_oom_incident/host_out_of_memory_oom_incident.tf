resource "shoreline_notebook" "host_out_of_memory_oom_incident" {
  name       = "host_out_of_memory_oom_incident"
  data       = file("${path.module}/data/host_out_of_memory_oom_incident.json")
  depends_on = [shoreline_action.invoke_stop_disable_service]
}

resource "shoreline_file" "stop_disable_service" {
  name             = "stop_disable_service"
  input_file       = "${path.module}/data/stop_disable_service.sh"
  md5              = filemd5("${path.module}/data/stop_disable_service.sh")
  description      = "Reduce the number of applications or processes running on the host by shutting down unneeded services."
  destination_path = "/agent/scripts/stop_disable_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_stop_disable_service" {
  name        = "invoke_stop_disable_service"
  description = "Reduce the number of applications or processes running on the host by shutting down unneeded services."
  command     = "`chmod +x /agent/scripts/stop_disable_service.sh && /agent/scripts/stop_disable_service.sh`"
  params      = ["SERVICE_NAME"]
  file_deps   = ["stop_disable_service"]
  enabled     = true
  depends_on  = [shoreline_file.stop_disable_service]
}

