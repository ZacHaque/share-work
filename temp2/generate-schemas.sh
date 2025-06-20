#!/bin/bash

# List of schema names
schema_names=("user" "order" "product")
# schema_names=("user")


# Overlay to use (dev or prod)
overlay="${1:-dev}"  # default to 'dev' if not passed

# Validate overlay
if [[ "$overlay" != "dev" && "$overlay" != "prod" ]]; then
  echo "Overlay must be 'dev' or 'prod'"
  exit 1
fi

base_dir="/Users/zac/my_workshop/kustomize/testing/base"
overlay_dir="/Users/zac/my_workshop/kustomize/testing/overlays/${overlay}"
output_dir="/Users/zac/my_workshop/kustomize/testing/output"

for schema in "${schema_names[@]}"; do
  echo "🔧 Generating CR for schema: $schema using overlay: $overlay"

  # Create a temp base CR file with the schema name injected
  temp_cr="${base_dir}/schema-${schema}.yaml"

  cat > "$temp_cr" <<EOF
apiVersion: platform.confluent.io/v1beta1
kind: Schema
metadata:
  name: ${schema}-schema
spec:
  subject: ${schema}
  format: avro
  schemaRegistry:
    url: http://placeholder-schema-registry:8081
    
EOF

  # Create temporary kustomization.yaml pointing to the generated file
  echo "resources:
  - schema-${schema}.yaml" > "$base_dir/kustomization.yaml"


  # Create a temp base CR file with the schema name injected
  temp_overlay_cr="${overlay_dir}/patch-schema-endpoint.yaml"

  cat > "$temp_overlay_cr" <<EOF
apiVersion: platform.confluent.io/v1beta1
kind: Schema
metadata:
  name: ${schema}-schema

spec:
  schemaRegistry:
    url: http://dev-schema-registry.confluent:8081

EOF


  # Dry-run to view final output
  echo "🚀 Dry-run output for schema: $schema"
  kubectl apply --dry-run=client -k "$overlay_dir" -o yaml > ${output_dir}/${overlay}-${schema}-schema.yaml

  echo "---------------------------"

  # Optionally clean up:
  rm -f "$temp_cr"
done
