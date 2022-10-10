# syntax=docker/dockerfile:1
# this line above was added for buildkit support, probably not needed now

FROM nvcr.io/nvidia/pytorch:22.08-py3 AS testruntime

# check cuda is available during build
RUN python -c 'import torch;print(torch.cuda.is_available());print(torch.__version__)'
RUN ls /dev/nvidia*
RUN nvidia-smi                                                                                                                                                                                         


# ------------------- #

FROM nvcr.io/nvidia/pytorch:22.08-py3

WORKDIR /tmp
# an older version of xformer with slightly different API
RUN pip install git+https://github.com/facebookresearch/xformers@51dd119 --verbose
# clip model using memory efficient attention
RUN	pip install transformers git+https://github.com/cccntu/transformers@33c59f3016 --verbose && \
  pip install ftfy scipy
# stable diffusion using memory efficient attention + fp16 without autocast
RUN  pip install git+https://github.com/cccntu/diffusers@ef35f234 --verbose

# set id, so the files created in the docker will have the right permission
# see: https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID
# by default, home will be created and set at /home/user
RUN addgroup --gid $GROUP_ID user && \
  adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user # --home /working
# set user and working directory, optional, can be re-written with `docker run -w <dir> --user <uid>:<gid>`
USER user

WORKDIR /home/user
