# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "nvidia/map.jinja" import nvidia with context %}

{## Configure package managers for repository information ##}
nvidia-repo:
  pkgrepo.managed:
    - humanname: cuda
    - gpgcheck: 1
  {% if salt['grains.get']('os_family', 'RedHat') == 'RedHat' %}
    - gpgkey: {{ nvidia.base_url }}/GPGKEY
    - baseurl: {{ nvidia.base_url }}/rhel$releasever/$basearch
  {% elif salt['grains.get']('os_family') == 'Debian' or 'Ubuntu' %}
    - file: /etc/apt/sources.list.d/nvidia.list
    - key_url: {{ nvidia.base_url }}//ubuntu{{ salt['grains.get']('osrelease', '1404') | replace('.','') }}/{{ salt['grains.get']('osarch','x86_64') | replace('amd64','x86_64') }}/7fa2af80.pub
    - name: deb {{ nvidia.base_url }}/ubuntu{{ salt['grains.get']('osrelease', '1404') | replace('.','') }}/{{ salt['grains.get']('osarch','x86_64') | replace('amd64','x86_64') }} /
  {% endif %}

{## Install cuda drivers ##}
install_cuda_package:
  pkg.installed:
    - name: cuda
  {%- if nvidia.version is defined %}
    - version: {{ nvidia.version }}
  {% endif %}
    - require:
      - pkgrepo: nvidia-repo

{## Disable Nouveau ##}
/etc/modprobe.d/blacklist-nouveau.conf:
  file.managed:
    - source: salt://nvidia/files/blacklist-nuveau.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_cuda_package

{## Rebuild Initramfs ##}
{% if nvidia.rebuild_initrd_cmd is defined %}
nvidia_rebuild_inird_cmd:
  cmd.run:
    - name: {{ nvidia.rebuild_initrd_cmd }}
    - creates:
      - /lib/modules/{{ salt['grains.get']('kernelrelease', '') }}/extras/nvidia.ko
    - require:
      - pkg: install_cuda_package
{% endif %}

# This is to set up the cuda path variable sourced by users.
/etc/profile.d/cuda.sh:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - source: salt://nvidia/files/cuda.sh
    - require:
      - pkg: install_cuda_package
