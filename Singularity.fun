Bootstrap:docker
From:continuumio/miniconda3

%files
    fun.yml
    conda.envscript

%post
    . /opt/conda/etc/profile.d/conda.sh
    conda activate
    conda env create -f fun.yml -n myenv
    # copy a script to activate myenv whenever the container starts up
    cp conda.envscript .singularity.d/env/
    echo 'source /.singularity.d/env/conda.envscript' >> $SINGULARITY_ENVIRONMENT
    # dangerous wizardry below required to change from sh to bash for env sourcing
    rm /bin/sh
    ln -s /bin/bash /bin/sh
