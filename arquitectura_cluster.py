from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Openvswitch
from diagrams.onprem.security import Freeipa
from diagrams.onprem.database import Postgresql

with Diagram(name="Clúster OpenShift", show=False):
    with Cluster("Servidor ProLiant DL380 (Rocky Linux)"):
        with Cluster("Nodos OpenShift"):
            bootstrap = Server("Bootstrap")
            masters = [Server(f"Master {i+1}") for i in range(3)]
            workers = [Server(f"Worker {i+1}") for i in range(3)]
            for master in masters:
                bootstrap >> master
                for worker in workers:
                    master >> worker

        with Cluster("Servicios de Red"):
            vpn = User("VPN (Bastion1)")
            ovs = Openvswitch("Open vSwitch")
            vpn >> ovs
            ovs >> bootstrap

        with Cluster("Monitoreo"):
            prometheus = Prometheus("Prometheus")
            grafana = Grafana("Grafana")
            prometheus >> grafana

        with Cluster("Servicios Adicionales"):
            freeipa = Freeipa("FreeIPA")
            load_balancer = Server("Load Balancer")
            nfs = Server("NFS")
            db = Postgresql("PostgreSQL")
            freeipa >> load_balancer
            nfs >> load_balancer
            db >> load_balancer

        redis = Redis("Base de Datos Redis (Session HA)")
        
        # Conexiones
        vpn >> [bootstrap] + masters + workers
        redis >> [bootstrap] + masters + workers
        prometheus >> workers
        load_balancer >> [masters + workers]
