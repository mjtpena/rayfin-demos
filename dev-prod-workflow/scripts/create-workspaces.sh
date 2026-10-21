#!/usr/bin/env bash
# Step 1 helper: create the my-app-dev and my-app-prod Fabric workspaces and
# print their IDs. Same result as creating them by hand in the Fabric portal.
#
# Requires the Azure CLI, signed in to the target tenant (az login).
#
# Usage:
#   ./scripts/create-workspaces.sh [capacity-id]
#
# Pass a capacity ID (or set FABRIC_CAPACITY_ID) to assign the new workspaces to
# a Fabric capacity. Existing workspaces with the same name are reused.
set -euo pipefail

FABRIC=https://api.fabric.microsoft.com
CAPACITY_ID="${1:-${FABRIC_CAPACITY_ID:-}}"

fabric() {
  az rest --resource "$FABRIC" "$@"
}

for name in my-app-dev my-app-prod; do
  id=$(fabric --method get --url "$FABRIC/v1/workspaces" \
    --query "value[?displayName=='$name'].id | [0]" -o tsv)

  if [[ -z "$id" ]]; then
    body="{\"displayName\":\"$name\"${CAPACITY_ID:+,\"capacityId\":\"$CAPACITY_ID\"}}"
    id=$(fabric --method post --url "$FABRIC/v1/workspaces" --body "$body" --query id -o tsv)
    echo "Created workspace $name"
  else
    echo "Reusing workspace $name"
  fi

  echo "  $name  $id"
done
