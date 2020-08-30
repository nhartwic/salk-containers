Bootstrap:docker
From:continuumio/miniconda3

%files
    fun.yml
    runscript

%post
    . /opt/conda/etc/profile.d/conda.sh
    conda activate
    conda env create -f fun.yml -n myenv
    cp runscript .singularity.d/runscript

