
FROM arm64v8/ubuntu:latest

# To allow running dpkg (behind other tools like Apt) without interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

# Set the work directory and create the folder to copy requirement lists into
WORKDIR /app
# Install the prerequisites for the dependency lists
RUN mkdir docker \
	&& apt-get update \
	# && apt-get install -y ubuntu-server \
	&& apt-get upgrade -y

# Start with the apt dependency list since other lists depend on these packages
COPY ./dependencies-apt.conf /app/docker/
RUN apt-get update \
	&& sed 's/#.*//' docker/dependencies-apt.conf | tr -d '\r' | xargs apt-get install -y

# Next, install the apt dependencies from the snapcraft.yaml file
COPY ./dependencies-apt-snapcraft.conf /app/docker/
RUN apt-get update \
	&& sed 's/#.*//' docker/dependencies-apt-snapcraft.conf | tr -d '\r' | xargs apt-get install -y

# Next, configure python and load the python packages
COPY ./requirements.txt /app/docker/
RUN python3 -m pip install --upgrade pip \
	&& rm /usr/local/bin/pip \
	&& cp /usr/local/bin/pip3 /usr/local/bin/pip \
	&& pip3 install -r /app/docker/requirements.txt


STOPSIGNAL SIGRTMIN+3

# Command to run when the container starts (From the perspective of the container)
CMD /app/docker/_raspi/startup.sh
