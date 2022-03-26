all: output/docker/docker.qcow2

output/docker/docker.qcow2:
	rm -Rf output/docker
	packer build docker

clean:
	rm -Rf output