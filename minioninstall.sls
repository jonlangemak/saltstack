#Install docker
docker:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/sysconfig/docker
    - enable: true

#Make the kubernetes binary directory
/opt/kubernetes:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

#Pull down kubernetes binaries
/opt/kubernetes/kube-proxy:
  file:
    - managed
    - source: salt://kube_binaries/kube-proxy
    - user: root
    - group: root
    - mode: 755

/opt/kubernetes/kubelet:
  file:
    - managed
    - source: salt://kube_binaries/kubelet
    - user: root
    - group: root
    - mode: 755

#Pull down Systemd Service definitions
/usr/lib/systemd/system/kube-proxy.service:
  file:
    - managed
    - source: salt://systemd/kube-proxy.service
    - user: root
    - group: root
    - mode: 755

#Start Kubernetes services
kube-proxy:
  service:
    - running
    - enable: true

