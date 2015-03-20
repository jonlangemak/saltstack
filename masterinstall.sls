#Download etcd
etcd-install:
  archive.extracted:
    - name: /opt/
    - source: https://github.com/coreos/etcd/releases/download/v2.0.5/etcd-v2.0.5-linux-amd64.tar.gz
    - source_hash: md5=4d8ccff28c383980b52397a7664b3342
    - archive_format: tar
    - user: root
    - group: root
    - if_missing: /opt/etcd-v2.0.5-linux-amd64/

#Make symlink for etcdctl
/usr/local/bin/etcdctl:
  file.symlink:
    - target: /opt/etcd-v2.0.5-linux-amd64/etcdctl

/usr/lib/systemd/system/etcd.service:
  file:
    - managed
    - source: salt://systemd/etcd.service
    - user: root
    - group: root
    - mode: 755

etcd:
  service:
    - running
    - enable: true

#Make the kubernetes binary directory
/opt/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

#Pull down Kubernetes Binaries
/opt/kubernetes/kubectl:
  file:
    - managed
    - source: salt://kube_binaries/kubectl
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-apiserver:
  file:
    - managed
    - source: salt://kube_binaries/kube-apiserver
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-controller-manager:
  file:
    - managed
    - source: salt://kube_binaries/kube-controller-manager
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kube-scheduler:
  file:
    - managed
    - source: salt://kube_binaries/kube-scheduler
    - user: root
    - group: root
    - mode: 755


#Pull down Systemd Service definitions
/usr/lib/systemd/system/kube-apiserver.service:
  file:
    - managed
    - source: salt://systemd/kube-apiserver.service
    - user: root
    - group: root
    - mode: 755

/usr/lib/systemd/system/kube-controller.service:
  file:
    - managed
    - source: salt://systemd/kube-controller.service
    - user: root
    - group: root
    - mode: 755

/usr/lib/systemd/system/kube-scheduler.service:
  file:
    - managed
    - source: salt://systemd/kube-scheduler.service
    - user: root
    - group: root
    - mode: 755

#Start Kubernetes services
kube-apiserver:
  service:
    - running
    - enable: true

kube-controller:
  service:
    - running
    - enable: true

kube-scheduler:
  service:
    - running
    - enable: true

#Make symlink for kubectl
/usr/local/bin/kubectl:
  file.symlink:
    - target: /opt/kubernetes/kubectl

#Install SkyDNS Pod
/root/skydns:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

/root/skydns/skydns-svc.yaml:
  file:
    - managed
    - source: salt://pods/skydns/skydns-svc.yaml
    - user: root
    - group: root
    - mode: 755

/root/skydns/skydns-rc.yaml:
  file:
    - managed
    - source: salt://pods/skydns/skydns-rc.yaml
    - user: root
    - group: root
    - mode: 755

skydns-service:
  cmd.run:
    - name: kubectl create -f /root/skydns/skydns-svc.yaml

skydns-rc:
  cmd.run:
    - name: kubectl create -f /root/skydns/skydns-rc.yaml

#Install Heapster Pod
/root/heapster:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

/root/heapster/grafana-svc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/grafana-svc.yaml
    - user: root
    - group: root
    - mode: 755

/root/heapster/heapster-rc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/heapster-rc.yaml
    - user: root
    - group: root
    - mode: 755

/root/heapster/heapster-svc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/heapster-svc.yaml
    - user: root
    - group: root
    - mode: 755

/root/heapster/influxdb-grafana-rc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/influxdb-grafana-rc.yaml
    - user: root
    - group: root
    - mode: 755

/root/heapster/influxdb-svc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/influxdb-svc.yaml
    - user: root
    - group: root
    - mode: 755

/root/heapster/influxdb-ui-svc.yaml:
  file:
    - managed
    - source: salt://pods/heapster/influxdb-ui-svc.yaml
    - user: root
    - group: root
    - mode: 755

grafana-svc:
  cmd.run:
    - name: kubectl create -f /root/heapster/grafana-svc.yaml

heapster-svc:
  cmd.run:
    - name: kubectl create -f /root/heapster/heapster-svc.yaml

influxdb-svc:
  cmd.run:
    - name: kubectl create -f /root/heapster/influxdb-svc.yaml

influxdb-ui-svc:
  cmd.run:
    - name: kubectl create -f /root/heapster/influx-ui-svc.yaml

heapster-rc:
  cmd.run:
    - name: kubectl create -f /root/heapster/heapster-rc.yaml

influxdb-grafana-rc:
  cmd.run:
    - name: kubectl create -f /root/heapster/influxdb-grafana-rc.yaml
