FROM continuumio/miniconda3

# specify  environment yml:
COPY fun.yml environment.yml

# build provided env
RUN conda env create -f environment.yml -n myenv
RUN echo "source activate myenv" > ~/.bashrc

# force bash to be used instead of shell
run rm /bin/sh && ln -s /bin/bash /bin/sh

# fix diamond version by manually installing
run wget http://github.com/bbuchfink/diamond/releases/download/v0.9.21/diamond-linux64.tar.gz && \
    tar -zxf diamond-linux64.tar.gz && \
    mv diamond /opt/conda/envs/myenv/bin/diamond

# build singularity dir structure to hopefully hack singularity functionality when relevant
run mkdir -p /.singularity.d/env
# run echo '#!/bin/bash' >> /.singularity.d/env/91-environment.sh
run echo '. /opt/conda/etc/profile.d/conda.sh' >> /.singularity.d/env/91-environment.sh
run echo 'conda activate myenv' >> /.singularity.d/env/91-environment.sh

# Make RUN commands use the new environment (for docker execution):
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

