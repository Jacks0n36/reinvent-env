# Use the official Miniconda image
FROM continuumio/miniconda3:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install git gcc g++ && \
    rm -rf /var/lib/apt/lists/*

# Copy the reinvent.yml file into the Docker image
COPY reinvent.yml .

RUN conda env create -f reinvent.yml && \
    conda clean --all -afy

# Install pip manually in case it is missing in the environment
RUN conda run -n reinvent.v3.2 python -m ensurepip --upgrade
RUN conda run -n reinvent.v3.2 python -m pip install --upgrade pip setuptools wheel

RUN conda create "python>=3.8,<3.10" -n aizynth && \
    conda run -n aizynth python -m pip install aizynthfinder && \
    conda clean --all -afy && \
    pip cache purge

ARG CACHEBUST
RUN cd /home && \
    git clone -b plugins https://github.com/Jacks0n36/Reinvent && \
    git clone https://github.com/connorcoley/scscore
ENV PYTHONPATH=/home/Reinvent:/home/scscore
ENV PATH=/opt/conda/bin:$PATH

# Set the default shell to use bash and activate the conda environment
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "reinvent.v3.2"]
