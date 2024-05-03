from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.generic.os import RedHat
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.network import Nginx
from diagrams.onprem.queue import Kafka

with Diagram(name="Detailed Clúster OpenShift Architecture", show=False):
    with Cluster("Data Center Infrastructure"):
        with Cluster("Servidor ProLiant DL380 (Rocky Linux)"):
            with Cluster("Nodos OpenShift"):
                bootstrap = Server("Bootstrap Node")
                masters = [Server(f"Master Node {i+1}") for i in range(3)]
                workers = [Server(f"Worker Node {i+1}") for i in range(3)]

                bootstrap >> masters
                for master in masters:
                    master >> workers

            with Cluster("Servicios de Red"):
                vpn = User("VPN (Bastion1)")
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

                freeipa >> load_balancer
                nfs >> load_balancer
                db >> load_balancer

            redis = Redis("Base de Datos Redis (Session HA)")
            redis >> masters
            redis >> workers

            # Correct connection setup
            for master in masters:
                vpn >> master
            for worker in workers:
                vpn >> worker

            load_balancer >> masters
            load_balancer >> workers
            prometheus >> workers
