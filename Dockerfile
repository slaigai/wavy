ARG BASE_IMAGE=ubuntu:20.04

FROM $BASE_IMAGE as prod

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=TRUE
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	apt-utils \
	build-essential \
	libbz2-dev \
	libffi-dev \
	libgdbm-dev \
	libjpeg-dev \
	libncursesw5-dev \
	libpq-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	libtiff-dev \
	libxml2-dev \
	libxslt1-dev \
	python-dev \
	python3-dev \
	zlib1g-dev
RUN apt-get install -y --no-install-recommends python-is-python3 python3.8-venv

# Switch over to the venv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install setuptools
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN python -m pip install readline

# Install pyaudio
RUN apt-get install -y portaudio19-dev


# Install dependencies
ADD requirements.txt /code/requirements.txt
RUN cd /code && python -m pip install -r requirements.txt

# Set up runtime
WORKDIR /code
CMD ["tail", "-f", "/dev/null"]
