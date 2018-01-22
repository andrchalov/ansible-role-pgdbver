#!/bin/bash

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)
docker_lib_volume="/var/lib/docker"

if [ "$container_id" ]; then
  docker_lib_volume="${container_id}_volume:/var/lib/docker"

fi

# Allow environment variables to override defaults.
playbook=${playbook:-"test.yml"}
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: andrchalov/docker-ansible:latest."${neutral}"\n"
docker pull andrchalov/docker-ansible:latest
docker run --detach -v="$docker_lib_volume" --volume="$PWD":/etc/ansible/roles/role_under_test:rw --privileged --name $container_id $opts andrchalov/docker-ansible:latest $init

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook"${neutral}
docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook

# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf "Removing Docker container...\n"
  docker rm -fv $container_id
fi
