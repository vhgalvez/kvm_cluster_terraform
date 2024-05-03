from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.generic.os import RedHat
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Nginx
from diagrams.elastic.elasticsearch import Elasticsearch, Kibana
from diagrams.onprem.network import Bind9, Traefik

with Diagram(name="Detailed Clúster OpenShift Architecture kvm", show=False):
    with Cluster("Data Center Infrastructure"):
        # Central physical server representation
        with Cluster("Physical Server: ProLiant DL380 (Rocky Linux)"):
            physical_server = RedHat("Main Server")

            # OpenShift Nodes setup
            with Cluster("OpenShift Nodes"):
                bootstrap = Server("Bootstrap Node")
                masters = [Server(f"Master Node {i+1}") for i in range(3)]
                workers = [Server(f"Worker Node {i+1}") for i in range(3)]

                physical_server >> bootstrap
                bootstrap >> masters
                for master in masters:
                    master >> workers

            # Network services with VPN and Open vSwitch
            with Cluster("Network Services"):
                vpn = User("VPN (Bastion1) - Public IP via Fiber Optic")
                ovs = RedHat("Open vSwitch")

                vpn >> ovs
                ovs >> bootstrap

            # Monitoring setup with Prometheus and Grafana
            with Cluster("Monitoring"):
                prometheus = Prometheus("Prometheus")
                grafana = Grafana("Grafana")
                prometheus >> grafana

            # Additional Services setup with FreeIPA, Load Balancer, NFS, and Database
            with Cluster("Additional Services"):
                freeipa = RedHat("FreeIPA")
                load_balancer = Traefik("Load Balancer")
                nfs = Server("NFS Server")
                db = PostgreSQL("PostgreSQL Database")
                elasticsearch = Elasticsearch("Elasticsearch")
                kibana = Kibana("Kibana")
                dns = Bind9("DNS Server")

                freeipa >> load_balancer
                nfs >> load_balancer
                db >> load_balancer
                elasticsearch >> kibana
                load_balancer >> [elasticsearch, kibana, dns]

            # Redis configuration for session high availability
            redis = Redis("Redis (Session HA)")
            redis >> [masters, workers]

            # Connection setup from VPN to all nodes and load balancing
            vpn >> [masters, workers]
            load_balancer >> [masters, workers]
            prometheus >> workers
            grafana >> kibana
