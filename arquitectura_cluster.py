from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.network import Openvswitch
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.security import Freeipa

with Diagram(name="Clúster OpenShift", show=False):
    with Cluster("Servidor ProLiant DL380 (Rocky Linux)"):
        with Cluster("Nodos OpenShift"):
            bootstrap = Server("Bootstrap")
            master = [Server(f"Master {i+1}") for i in range(3)]
            worker = [Server(f"Worker {i+1}") for i in range(3)]

            bootstrap >> master >> worker

        with Cluster("Servicios de Red"):
            vpn = User("VPN (Bastion1)")
            ovs = Openvswitch("Open vSwitch")
            ovs - vpn

        with Cluster("Monitoreo"):
            prometheus = Prometheus("Prometheus")
            grafana = Grafana("Grafana")
            prometheus >> grafana

        with Cluster("Servicios Adicionales"):
            freeipa = Freeipa("FreeIPA")
            lb = Server("Load Balancer")
            freeipa - lb

        redis = Redis("Base de Datos Redis (Session HA)")

        # Conexiones
        ovs >> bootstrap
        vpn >> [master, worker]
        lb >> [master, worker]
        redis >> [master, worker]
        prometheus >> worker
