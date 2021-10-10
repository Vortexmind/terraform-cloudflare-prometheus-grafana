# 👷 Sample Prometheus & Grafana terraform stack to monitor a Cloudflare zone

A sample environment on Digitalocean for monitoring the metrics of a given Cloudflare zone using GraphQL API.

- The environment (Prometheus / Grafana / Prometheus Exporter) runs in Digitalocean
- Grafana is exposed on a configurable FQDN of the monitored domain. 
- Grafana is protected by Cloudflare Access
- The Grafana instance is reachable via a Cloudflare Tunnel
 
## Documentation
https://www.paolotagliaferri.com/monitor-your-website-with-cloudflare-prometheus-grafana/

## License
This work is available under [MIT License](https://github.com/Vortexmind/terraform-cloudflare-prometheus-grafana/blob/main/LICENSE)
