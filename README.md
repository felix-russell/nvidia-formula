nvidia Salt formula
========

This formula is intended to download and install the nvidia drivers for your operating system for use with the CUDA libraries.

See the full Salt Formulas installation and usage instructions
<http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>

Authors
----
(c)2017 University of Washington, Institute for Health Metrics and Evaluation
 - Andrew Ernst (ernstae@github.com)
 - Felix Russell (felix-russell@github.com)


Available states
================

```
  nvidia.install
```
This formula can be called as `salt-call state.sls nvidia` and relies on the presence of either a salt grain for gpus (see https://docs.saltstack.com/en/latest/ref/configuration/master.html for the `ENABLE_GPU_GRAINS` feature.)


Tested Operating Systems
----
* Ubuntu 14.04 16.04
* Centos 6.x  7.x
* RedHat 6.x 7.x
