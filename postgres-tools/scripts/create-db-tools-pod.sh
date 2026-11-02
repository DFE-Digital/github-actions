#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

required NAMESPACE
required DB_TOOLS_POD_NAME
required SECRET_REF_NAME
required TEMPLATE_FILE

export NAMESPACE
export DB_TOOLS_POD_NAME
export SECRET_REF_NAME

envsubst < "$TEMPLATE_FILE" \
  | kubectl apply -n "$NAMESPACE" -f -

kubectl wait \
  --for=condition=Ready \
  pod/$DB_TOOLS_POD_NAME \
  -n "$NAMESPACE" \
  --timeout=120s
