from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.client import User
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.monitoring import Grafana, Prometheus

with Diagram(name="Clúster OpenShift", show=False):
    with Cluster("Servidor ProLiant DL380 (Rocky Linux)"):
        with Cluster("Nodos OpenShift"):
            bootstrap = Server("Bootstrap")
            master = [Server(f"Master {i+1}") for i in range(3)]
            worker = [Server(f"Worker {i+1}") for i in range(3)]

            for m in master:
                bootstrap >> m
                for w in worker:
                    m >> w

        with Cluster("Servicios de Red"):
            vpn = User("VPN (Bastion1)")
            vpn - bootstrap  # Direct connection for illustration

        with Cluster("Monitoreo"):
            prometheus = Prometheus("Prometheus")
            grafana = Grafana("Grafana")
            prometheus >> grafana

        redis = Redis("Base de Datos Redis (Session HA)")

        # Conexiones
        vpn >> [bootstrap] + master + worker
        redis >> [bootstrap] + master + worker
        prometheus >> worker
