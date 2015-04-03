policycoreutils:
  pkg.installed
policycoreutils-python:
  pkg.installed

selinux-config:
  file.sed:
    - name: /etc/selinux/config
    - before: (permissive|enforcing)$
    - after: disabled
    - limit: ^SELINUX=

disable-selinux:
  cmd.run:
    - name: /usr/sbin/setenforce 0

temp-package-fix1:
  cmd.run:
    - name: yum-config-manager --enable public_ol6_latest

temp-package-fix2:
  cmd.run:
    - name: yum --assumeyes install device-mapper-event-libs

firewalld:
  service:
    - dead
    - enable: false

