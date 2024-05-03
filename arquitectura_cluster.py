from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.generic.os import RedHat
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Nginx
from diagrams.onprem.queue import Kafka
from diagrams.elastic.elasticsearch import Elasticsearch, Kibana

with Diagram(name="Detailed Clúster OpenShift Architecture", show=False):
    with Cluster("Data Center Infrastructure"):
        with Cluster("Physical Server: ProLiant DL380 (Rocky Linux)"):
            # Highlighting the server as a central point
            main_server = Server("Main Server")

            with Cluster("Nodos OpenShift"):
                bootstrap = Server("Bootstrap Node")
                masters = [Server(f"Master Node {i+1}") for i in range(3)]
                workers = [Server(f"Worker Node {i+1}") for i in range(3)]
                
                main_server >> bootstrap
                bootstrap >> masters
                for master in masters:
                    master >> workers

            with Cluster("Servicios de Red"):
                vpn = User("VPN (Bastion1) - Public IP via Fiber Optic")
                ovs = RedHat("Open vSwitch")
                vpn >> ovs
                ovs >> bootstrap

            with Cluster("Monitoreo"):
                prometheus = Prometheus("Prometheus")
                grafana = Grafana("Grafana")
                prometheus >> grafana

            with Cluster("Servicios Adicionales"):
                freeipa = RedHat("FreeIPA")
                load_balancer = Server("Load Balancer")
                nfs = Server("NFS Server")
                db = PostgreSQL("PostgreSQL Database")
                elasticsearch = Elasticsearch("Elasticsearch")
                kibana_instance = Kibana("Kibana")

                freeipa >> load_balancer
                nfs >> load_balancer
                db >> load_balancer
                elasticsearch >> kibana_instance
                load_balancer >> [elasticsearch, kibana_instance]

            redis = Redis("Base de Datos Redis (Session HA)")
            redis >> [masters, workers]

            # Connections
            vpn >> [masters, workers]
            load_balancer >> [masters, workers]
            prometheus >> workers
            grafana >> kibana_instance
