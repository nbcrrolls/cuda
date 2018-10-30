

CUDA  Roll
==================

.. contents::

Introduction
---------------
This roll installs NVIDIA CUDA Toolkit and NVIDIA Driver.
Versions of toolkit and driver are specified in ``cuda.mk`` file.
To build with differnt version see section Requirements below.
For more information about the NVIDIA CUDA Toolkit please see the official
`NVIDIA developer website <http://developer.nvidia.com>`_

Requirements
-------------

The toolkit distro is ~1Gb.  
Must have enough space (~ 1.5GB) in / when building the roll.

Building
-------------

Download the roll source from the git repository. A default  location  to build rolls 
on rocks cluster is ``/export/site-roll/rocks/src/`` ::

    # cd /export/site-roll/rocks/src/
    # git clone https://github.com/nbcrrolls/cuda
    # cd cuda
    # ./bootstrap.sh
 
The last command downloads cuda toolkit and driver sources from the google drive. The versions are
defined in cuda.mk file. If you want to build the roll using different verisons of the toolkiit and the driver
please see a section ``Building a different verson`` below.

To build the roll, execute : ::

    # make 2>&1 | tee build.log

A successful build will create  ``cuda-*.x86_64*.iso`` file.


Building a different version
-----------------------------

To use different versions of the toolkit and the driver, instead of  executing ``./bootstrap.sh``
download the desired CUDA toolkit and driver source files (``*run`` format)  from : 

+ `NVIDIA CUDA toolkit <https://developer.nvidia.com/cuda-downloads>`_  
+ `NVIDIA drivers <http://www.nvidia.com/drivers>`_

and place them in respective directories in ``src/nvidia-driver``
and ``src/nvidia-toolkit``. Update ``cuda.mk`` file with new version numbers.

NVIDIA changes the naming schema  for the toolkit and driver files with each major version update. 
Depending on your downloaded toolkit and driver versions,  you may need to update 
the variables (that refer to the downloaded toolkit and driver source files) in 
``src/nvidia-toolkit/version.mk`` and /src/nvidia-driver/version.mk`` and then verify a build process
just for RPMs: ::

    # cd src/nvidia-toolkit; make rpm
    # cd src/nvidia-driver; make rpm
    
Both commands should result in building the corresponding RPM after which one can build the roll.
To build the roll, execute  form the top repo directory (cuda) : ::

    # make 2>&1 | tee build.log    


Installing
------------

To add this roll to existing cluster, execute these instructions on a Rocks frontend node: ::

    # rocks add roll *.iso
    # rocks enable roll cuda
    # (cd /export/rocks/install;  rocks create distro)
    # rocks run roll cuda > add-roll.sh

And on login/frontend node execute resulting add-roll.sh: ::

    # bash add-roll.sh 2>&1 | tee  add-roll.out
    
To install on GPU-enabled compute nodes (similar instructions for GPU-enabled vm-ontainers nodes)
Set node attribute : ::   

    # rocks set host attr compute-X-Y cuda true

On each GPU node disable nouveau driver and create new grub configuration and build a new initramfs ::

    # /opt/cuda_XY/bin/disable-nouveau

Reinstall compute nodes (only GPU-enabled):  ::
    
    # rocks set host boot compute-X-Y action=install
    # rocks run host compute-X-Y reboot

The compute nodes can be also updated with cuda roll without a rebuild. After 
a cuda roll is intaleld on the frontend, execute on each compute node: ::

    # yum clean all
    # yum install cuda-nvidia-driver cuda-toolkitXY cuda-toolkitXY-lib64 cuda-toolkitXY-base cuda-moduleXY 
    # yum install freeglut-devel
    # /sbin/chkconfig --add  nvidia 
    # /opt/cuda_XY/bin/disable-nouveau
    # reboot

where XY is the short hand notation of the cuda toolkit version.

What is installed 
-----------------

The following is installed with cuda roll: ::

    /opt/cuda/driver/ - NVIDIA driver
    /etc/rc.d/init.d/nvidia  - nvidia startup/shutdown script (disabled on login/frontend node)
    /etc/modprobe.d/disable-nouveau.conf - blacklist nouveau  configuraion file 
    /opt/cuda_XY/  - CUDA toolkit 
    /opt/cuda_XY/etc/nvidia-smi-commands - example list of nvidia-smi commands 
    /opt/cuda_XY/bin/disable-nouveau - script to permanently disable nouveau driver

where XY is the short hand notation of the cuda toolkit version.
Dependencies RPMS (needed for some cuda sample and cuda toolkit applications) installed :  ::

    freeglut
    freeglut-devel
    mesa-libGLU

On login/frontend nodes: ::

    /opt/cuda_XY/samples  - CUDA toolkit samples
    /opt/cuda_XY/doc  - CUDA toolkit documentation
    /var/www/html/cuda - link to cuda html documentation, will be availble via http://your.host.fqdn/cuda

In addition to the software, the roll installs cuda environment
module files in: ::

    /usr/share/Modules/modulefiles  (for CentOS 7)   
    /opt/modulefiles/applications/cuda  (for CentOS 6)

Modules set all needed environment for using cuda  toolkit. To use the modules: ::

    % module load cuda 


Testing
----------

The tests commands are run on GPU-enabled nodes. 

To find information about installed GPU card execute: ::

    nvidia-smi

Run GPU device tests : ::

    % /opt/cuda_XY/bin/deviceQuery
    % /opt/cuda_XY/bin/deviceQueryDrv
    % /opt/cuda_XY/bin/bandwidthTest 
    % /opt/cuda_XY/bin/p2pBandwidthLatencyTest

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
