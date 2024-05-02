from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Openvswitch
from diagrams.onprem.security import Freeipa
from diagrams.onprem.database import Postgresql


with Diagram(name="Detailed Clúster OpenShift Architecture", show=False):
    with Cluster("Data Center Infrastructure"):
        # Define the physical server hosting the cluster
        with Cluster("Servidor ProLiant DL380 (Rocky Linux)"):
            # Node setup for OpenShift
            with Cluster("Nodos OpenShift"):
                bootstrap = Server("Bootstrap Node")
                masters = [Server(f"Master Node {i+1}") for i in range(3)]
                workers = [Server(f"Worker Node {i+1}") for i in range(3)]
                
                # Connect bootstrap to all masters, then masters to all workers
                for master in masters:
                    bootstrap >> master
                    for worker in workers:
                        master >> worker

            # Network services including VPN and Open vSwitch
            with Cluster("Servicios de Red"):
                vpn = User("VPN (Bastion1)")
                ovs = Openvswitch("Open vSwitch")

                # VPN connected to Open vSwitch, which in turn connects to bootstrap node
                vpn >> ovs >> bootstrap

            # Monitoring setup with Prometheus and Grafana
            with Cluster("Monitoreo"):
                prometheus = Prometheus("Prometheus")
                grafana = Grafana("Grafana")

                # Data flow from Prometheus to Grafana
                prometheus >> grafana

            # Additional essential services like FreeIPA, Load Balancer, NFS, and PostgreSQL
            with Cluster("Servicios Adicionales"):
                freeipa = Freeipa("FreeIPA")
                load_balancer = Server("Load Balancer")
                nfs = Server("NFS Server DNS")
                db = Postgresql("PostgreSQL Database")

                # Interconnections between additional services
                freeipa >> load_balancer
                nfs >> load_balancer
                db >> load_balancer

            # Redis setup for session high availability
            redis = Redis("Base de Datos Redis (Session HA)")

            # General connections
            # VPN provides direct access to all nodes
            vpn >> masters
            vpn >> workers

            # Load balancer distributes load across all masters and workers
            load_balancer >> masters
            load_balancer >> workers

            # Redis provides database services to all nodes
            redis >> masters
            redis >> workers

            # Monitoring with Prometheus applied to all workers
            prometheus >> workers
            
            

