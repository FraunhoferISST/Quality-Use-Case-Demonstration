#!/bin/bash
#
# Copyright (c) 2024 Fraunhofer-Gesellschaft zur Foerderung der angewandten Forschung e.V. (represented by Fraunhofer ISST)
# Copyright (c) 2024 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0
#

cleanup=0
edc_only=0
int_seed=0
logs=0
# Remove previous installations if -c flag has been specified, and generate new keys
while getopts "ceilh" opt;do
  case $opt in
    c)
      echo "Cleanup requested."
      cleanup=1
      ;;
    e)
      echo "Only start with EDC. Restarts EDC if already existing"
      edc_only=1
      ;;
    i)
      echo "Alright, we'll seed the INT Test Data."
      int_seed=1
      ;;
    l)
          echo "Alright, you'll see the logs of the edc, dtr, puris."
          logs=1
          ;;
    h)
      echo "By default the tool does the following:"
      echo "- ensure that environment and keys have been generated"
      echo "- startup infrastructure, if needed"
      echo "- (delete and re-) start edc, dtr, puris"
      echo ""
      echo "If no option -e is provided, then start PURIS, with same result as running following commands:"
      echo "\$sh generate-keys.sh # if no .env exists"
      echo "\$docker compose -f docker-compose-infrastructure up # if no keycloak is running"
      echo "\$docker compose down -v"
      echo "\$docker compose up"
      echo ""
      echo "You can use options to alter behavior:"
      echo "-c clean         = run sh.cleanup before starting to create a new environment (Wallet, Keycloak, Keys)"
      echo "-e edc-only      = start only the EDCs with DTR and Data Base. Kill existing edc, dtr, db esources."
      echo "-i seed-int-data = TBD seed integration test data"
      echo "-l logs          = Follows the logs of the EDC, DTR and PURIS same as today with docker-compose."
      echo "-p puris         = start PURIS, same result as 'docker compose up' with previous 'docker compose down -v'"
      echo "\nExiting..."
      exit 1
      ;;
  esac
done

if [ $cleanup -eq 1 ]; then
  echo "Cleaning up previous installations and generating new keys..."
  sh cleanup.sh
fi

env_created=0
if [ ! -f ".env" ]; then
  echo "No environment given. Generating new one with keys..."
  env_created=1
  sh generate-keys.sh
  echo ""
else
  echo "Reusing existing environment."
fi

# consider running keycloak as infrastructure is already running
if [ "$(docker inspect --format='{{.State.Health.Status}}' keycloak)" = "healthy" ]; then
  echo "Infrastructure (Wallet, Keycloak) already running. Don't restart infrastructure."
else
  # Start the infrastructure services
  echo "Starting infrastructure services (Wallet, Keycloak) ..."
  docker compose -f docker-compose-infrastructure.yaml up -d

  # Wait for the infrastructure services to be fully up and running
  echo "...waiting for infrastructure services to be fully operational..."
  until [ "$(docker inspect --format='{{.State.Health.Status}}' keycloak)" = "healthy" ]; do
    printf '.'
    sleep 5
  done
  echo "Infrastructure services are up and running."
fi

# only seed bdrs, if the environment is new
if [ $env_created -eq 1 ]; then
  # Seed the bdrs-service
  echo "Seeding the bdrs-service..."
  sh seed-bdrs.sh
fi

if [ $edc_only -eq 1 ]; then

  # first down edc + dtr if running
  echo "Removing the EDCs with their DTR and Database..."
  docker compose down -v postgres-all dtr-customer dtr-supplier edc-customer-control-plane edc-customer-data-plane \
                         edc-supplier-control-plane edc-supplier-data-plane

  echo "We'll only start the the EDCs..."
  docker compose up -d edc-customer-control-plane edc-customer-data-plane edc-supplier-control-plane \
                       edc-supplier-data-plane

  echo "...waiting for EDCs to be fully operational..."
  until [ "$(docker inspect --format='{{.State.Health.Status}}' customer-control-plane)" = "healthy" -a \
          "$(docker inspect --format='{{.State.Health.Status}}' customer-data-plane)" = "healthy" -a \
          "$(docker inspect --format='{{.State.Health.Status}}' supplier-control-plane)" = "healthy" -a \
          "$(docker inspect --format='{{.State.Health.Status}}' supplier-data-plane)" = "healthy" ];
  do
    printf '.'
    sleep 5
  done
else
  echo "Removing the PURIS + EDCs with their DTR and Database..."
  docker compose down -v

  # Start the PURIS demonstrator containers
  echo "Starting PURIS demonstrator containers..."
  docker compose up -d

  # Wait for puris services to be fully up and running
#  echo "...waiting for backends to be fully operational..."
#  until [ "$(docker inspect --format='{{.State.Health.Status}}' customer-backend)" = "healthy" -a \
#          "$(docker inspect --format='{{.State.Health.Status}}' supplier-backend)" = "healthy" ];
#  do
#    printf '.'
#    sleep 5
#  done
  echo "Infrastructure services are up and running."
fi

echo "All services started successfully."

if [ $int_seed -eq 1 ]; then
  echo "Seeding Int Data: Not yet implemented."
  docker compose -f docker-compose-newman.yaml up
  echo "Seeded data. PLEASE CHECK RESULTS ON YOUR OWN."
fi

if [ $logs -eq 1 ]; then
  echo "Seeding Int Data: Not yet implemented."
#  docker compose logs -f dtr-customer edc-customer-control-plane edc-supplier-control-plane postgres-all \
#                         puris-backend-supplier puris-frontend-supplier dtr-supplier edc-customer-data-plane \
#                         edc-supplier-data-plane puris-backend-customer puris-frontend-customer
  docker compose logs -f dtr-customer edc-customer-control-plane edc-supplier-control-plane postgres-all \
                           dtr-supplier edc-customer-data-plane edc-supplier-data-plane
fi
