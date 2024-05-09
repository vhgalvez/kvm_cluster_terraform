chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh -i path/to/private_key core@<IP_VM>

chmod 600 /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift


ssh -v -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift <usuario>@<servidor_ip>

ssh -v -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.21 --p 22


> /root/.ssh/known_hosts
rm /root/.ssh/known_hosts


ssh -o StrictHostKeyChecking=no -i /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift core@10.17.3.21
sudo chmod 600 /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift
