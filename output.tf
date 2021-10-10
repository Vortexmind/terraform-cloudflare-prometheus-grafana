output "success_message" { 
    value = <<EOF
    
    Your droplet is up and running at ${digitalocean_droplet.prometheus_analytics.ipv4_address}
    
    Direct SSH Command (only allowed from ${chomp(data.http.my_ip.body)} : 
        ssh -i ${var.digitalocean_priv_key_path} root@${digitalocean_droplet.prometheus_analytics.ipv4_address}

    It takes some time for the Droplet to boot up and start the stack. To check progress, SSH in the droplet and run 
    less /var/log/cloud-init-output.log

    Once startup is complete, go to https://${local.cloudflare_fqdn} to reach your Grafana instance. The instance is behind Cloudflare 
    Access protection, you will need to enter your ${var.user_email} address to recieve an OTP token.
    After Cloudflare Access authentication, use the default `admin` (username) `admin` (password) to authenticate in Grafana.

    Remember to:
     - Add your Prometheus Data Source in Grafana (use http://prometheus:9090 for the URL)
     - Import the Grafana dashboard for a quick start: https://grafana.com/grafana/dashboards/13133


    EOF
}