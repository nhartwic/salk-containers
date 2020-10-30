FROM continuumio/miniconda3

# specify  environment yml:
COPY fun.yml environment.yml

# force bash to be used instead of shell
run rm /bin/sh && ln -s /bin/bash /bin/sh

# build needed env
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda env create -f environment.yml -n myenv && \
    conda activate myenv && \
    which pip && \
    python -m pip install --no-deps --force git+https://github.com/nextgenusfs/funannotate.git

# added conda activation to bashrc which maybe sometimes does something
RUN echo "source activate myenv" > ~/.bashrc

# build singularity dir structure to hopefully hack singularity functionality when relevant
run mkdir -p /.singularity.d/env
# run echo '#!/bin/bash' >> /.singularity.d/env/91-environment.sh
run echo '. /opt/conda/etc/profile.d/conda.sh' >> /.singularity.d/env/91-environment.sh
run echo 'conda activate myenv' >> /.singularity.d/env/91-environment.sh

# Make RUN commands use the new environment (for docker execution):
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

