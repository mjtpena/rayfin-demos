#!/usr/bin/env bash
# Steps 1 and 2 helper: create the deployment service principal, give it
# Contributor on the target Fabric workspace, and store its credentials as
# GitHub Actions repository secrets.
#
# Requires:
#   - az CLI signed in as a user who can create app registrations and is an
#     Admin of the target workspace (az login)
#   - gh CLI signed in with admin access to the repository (gh auth login)
#
# Usage:
#   ./scripts/setup-deployer.sh <workspace-name> <owner/repo> [capacity-id]
#
# The workspace is created (on the given capacity) if it doesn't exist yet.
# Re-running reuses the app registration and appends a fresh client secret.
# The secret value goes straight from az into gh and is never printed.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <workspace-name> <owner/repo> [capacity-id]" >&2
  exit 1
fi

WORKSPACE_NAME="$1"
REPO="$2"
CAPACITY_ID="${3:-}"
APP_NAME="${APP_NAME:-rayfin-github-deployer}"
FABRIC=https://api.fabric.microsoft.com

fabric() {
  az rest --resource "$FABRIC" "$@"
}

# --- Step 1: service principal ------------------------------------------------

CLIENT_ID=$(az ad app list --display-name "$APP_NAME" --query "[0].appId" -o tsv)
if [[ -z "$CLIENT_ID" ]]; then
  CLIENT_ID=$(az ad app create --display-name "$APP_NAME" \
    --sign-in-audience AzureADMyOrg --query appId -o tsv)
  echo "Created app registration $APP_NAME"
fi

SP_ID=$(az ad sp list --filter "appId eq '$CLIENT_ID'" --query "[0].id" -o tsv)
if [[ -z "$SP_ID" ]]; then
  SP_ID=$(az ad sp create --id "$CLIENT_ID" --query id -o tsv)
  echo "Created service principal for $APP_NAME"
fi

TENANT_ID=$(az account show --query tenantId -o tsv)
echo "  Application (client) ID: $CLIENT_ID"
echo "  Directory (tenant) ID:   $TENANT_ID"

# --- Step 1: workspace access -------------------------------------------------

WORKSPACE_ID=$(fabric --method get --url "$FABRIC/v1/workspaces" \
  --query "value[?displayName=='$WORKSPACE_NAME'].id | [0]" -o tsv)
if [[ -z "$WORKSPACE_ID" ]]; then
  body="{\"displayName\":\"$WORKSPACE_NAME\"${CAPACITY_ID:+,\"capacityId\":\"$CAPACITY_ID\"}}"
  WORKSPACE_ID=$(fabric --method post --url "$FABRIC/v1/workspaces" --body "$body" --query id -o tsv)
  echo "Created workspace $WORKSPACE_NAME"
fi
echo "  Workspace:               $WORKSPACE_NAME ($WORKSPACE_ID)"

ROLE=$(fabric --method get --url "$FABRIC/v1/workspaces/$WORKSPACE_ID/roleAssignments" \
  --query "value[?principal.id=='$SP_ID'].role | [0]" -o tsv)
if [[ -z "$ROLE" ]]; then
  # A brand-new service principal can take a few seconds to replicate.
  for attempt in 1 2 3 4 5 6; do
    if fabric --method post --url "$FABRIC/v1/workspaces/$WORKSPACE_ID/roleAssignments" \
      --body "{\"principal\":{\"id\":\"$SP_ID\",\"type\":\"ServicePrincipal\"},\"role\":\"Contributor\"}" \
      --output none 2>/dev/null; then
      ROLE=Contributor
      break
    fi
    echo "  Waiting for the service principal to replicate (attempt $attempt)..."
    sleep 10
  done
  [[ -n "$ROLE" ]] || { echo "Could not grant workspace access" >&2; exit 1; }
fi
echo "  Workspace role:          $ROLE"

# --- Step 2: repository secrets -----------------------------------------------

gh secret set CLIENT_ID --repo "$REPO" --body "$CLIENT_ID"
gh secret set TENANT_ID --repo "$REPO" --body "$TENANT_ID"
gh secret set FABRIC_WORKSPACE_NAME --repo "$REPO" --body "$WORKSPACE_NAME"
az ad app credential reset --id "$CLIENT_ID" --append \
  --display-name "github-actions $(date +%F)" --years 1 \
  --query password -o tsv | gh secret set CLIENT_SECRET --repo "$REPO"

echo "Done. Secrets set on $REPO: CLIENT_ID, TENANT_ID, CLIENT_SECRET, FABRIC_WORKSPACE_NAME"
