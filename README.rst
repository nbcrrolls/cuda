

CUDA  Roll
==================

.. contents::

Introduction
---------------
This roll installs NVIDIA CUDA Toolkit 7.0.28 and NVIDIA Driver v.346.59. 
For more information about the NVIDIA CUDA Toolkit please see the official
`NVIDIA developer website <http://developer.nvidia.com>`_

Requirements
-------------

To build/install this roll you need to download cuda toolkit and driver source files (``*.run`` format)
and plase them in respective directories in src/:

+ `NVIDIA CUDA toolkit <https://developer.nvidia.com/cuda-downloads>`_  
+ `NVIDIA drivers <http://www.nvidia.com/drivers>`_

The toolkit distro is ~1Gb.  
Must have enough space (~ 1.5GB) in / when building the roll.

Building
-------------

To build the roll, execute : ::

    # make 2>&1 | tee build.log

A successful build will create  ``cuda-*.x86_64*.iso`` file.

Installing
------------

To add this roll to existing cluster, execute these instructions on a Rocks frontend node: ::

    # rocks add roll *.iso
    # rocks enable roll cuda
    # cd /export/rocks/install
    # rocks create distro
    # rocks run roll cuda > add-roll.sh

And on login/frontend node execute resulting add-roll.sh: ::

    # bash add-roll.sh 2>&1 | tee  add-roll.out
    
Set attribute on GPU-enabled compute nodes: ::   

    # rocks set host attr compute-X-Y cuda true

Reinstall compute nodes (only GPU-enabled):  ::
    
    # rocks set host boot compute-X-Y action=install
    # rocks run host compute-X-Y reboot

After the compute node comes up reboot it again to initiate the
driver installation and loading. 

The compute nodes can be also updated with cuda roll without a rebuild. After 
a cuda roll is intaleld on the frontend, execute on each compute node: ::

    # yum clean all
    # yum install cuda-nvidia-driver cuda-toolkit75-lib64 cuda-toolkit75-base cuda-toolkit75-samples cuda-module75 mesa-libGLU
    # reboot

where the version on cuda-* RPMs is the version of cuda toolkit that was build. 

What is installed 
-----------------

The following is installed with cuda roll: ::

    /opt/cuda/driver - NVIDIA driver
    /etc/init.d/nvidia  - nvidia startup/shutdown script (disabled on login/frontend node)
    /opt/cuda   - toolkit (without samples on compute nodes)

Dependencies RPMS (needed for some cuda sample cuda toolkit applications): freeglut, freeglut-devel, mesa-libGLU
On login/frontend nodes: ::

    /opt/cuda/samples  - code samples
    /var/www/html/cuda - link to cuda html documentation

In addition to the software, the roll installs cuda environment
module files in: ::

    /opt/modulefiles/applications/cuda  (for CentOS 6)
    /usr/share/Modules/modulefiles  (for CentOS 7)   

Modules set all needed environmetn for using cuda  toolkit. To use the modules: ::

    % module load cuda 


Testing
----------

The tests commands are run on GPU-enabled nodes. 

To find information about installed GPU card execute: ::

    nvidia-smi

Run GPU device tests : ::

    % /opt/cuda/bin/deviceQuery
    % /opt/cuda/bin/deviceQueryDrv
    % /opt/cuda/bin/bandwidthTest 
    % /opt/cuda/bin/p2pBandwidthLatencyTest


CUDA and SGE
-------------

Some users reposrt increase in  virtual memory use when using CUDA. 
See following links for additional info. 

* http://gridengine.org/pipermail/users/2011-December/002215.html
* http://devblogs.nvidia.com/parallelforall/unified-memory-in-cuda-6/
* http://www.drdobbs.com/parallel/unified-memory-in-cuda-6-a-brief-overvie/240169095?pgno=2
* https://devtalk.nvidia.com/default/topic/493902/cuda-programming-and-performance/consumption-of-host-memory-increases-abnormally/
* http://stackoverflow.com/questions/6445109/why-is-my-c-program-suddenly-using-30g-of-virtual-memory
* http://gridengine.org/pipermail/users/2014-April/007468.html
* https://serverfault.com/questions/322073/howto-set-up-sge-for-cuda-devices

Useful commands: ::

    pmap -x PID
    more /proc/PID/smaps

GPU monitoring plugin for gmond

* https://github.com/ganglia/gmond_python_modules/tree/master/gpu/nvidia
