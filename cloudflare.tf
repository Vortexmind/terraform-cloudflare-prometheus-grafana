data "cloudflare_zones" "configured_zone" {
  filter {
    name   = var.cloudflare_domain
    status = "active"
  }
}

resource "cloudflare_argo_tunnel" "prometheus_analytics" {
  account_id = var.cloudflare_account_id
  name       = "prometheus_analytics"
  secret     = base64encode(var.cloudflare_tunnel_secret)
}

resource "cloudflare_record" "prometheus_app" {
  zone_id = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name    = var.cloudflare_cname_record
  value   = "${cloudflare_argo_tunnel.prometheus_analytics.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "ssh_app" {
  zone_id = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name    = var.cloudflare_ssh_cname_record
  value   = "${cloudflare_argo_tunnel.prometheus_analytics.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_access_application" "prometheus_analytics" {
  zone_id          = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name             = format("%s - Grafana",local.cloudflare_fqdn)
  type             = "self_hosted"
  domain           = local.cloudflare_fqdn
  session_duration = "30m"
}

resource "cloudflare_access_application" "ssh_browser" {
  zone_id          = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name             = format("%s - SSH browser",local.cloudflare_ssh_fqdn)
  type             = "ssh"
  domain           = local.cloudflare_ssh_fqdn
  session_duration = "30m"
}

resource "cloudflare_access_policy" "prometheus_analytics_policy" {
  application_id = cloudflare_access_application.prometheus_analytics.id
  zone_id        = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name           = "Allow Configured Users"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [var.user_email]
  }
}

resource "cloudflare_access_policy" "ssh_policy" {
  application_id = cloudflare_access_application.ssh_browser.id
  zone_id        = lookup(data.cloudflare_zones.configured_zone.zones[0], "id")
  name           = "Allow Configured Users"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [var.user_email]
  }
}


resource "cloudflare_access_ca_certificate" "ssh_short_lived" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.ssh_browser.id
}