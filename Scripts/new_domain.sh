#!/bin/sh

DOMAIN_NAME=$1

if [ -z "$DOMAIN_NAME" ]; then
  echo "Usage: $0 <domain-name>"
  exit 1
fi

# Auto-append "Domain" suffix if not already present
if [[ ! "$DOMAIN_NAME" =~ Domain$ ]]; then
  DOMAIN_NAME="${DOMAIN_NAME}Domain"
fi

# Confirm with user
echo "Creating domain: $DOMAIN_NAME"
read -p "Is this correct? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Cancelled."
  exit 0
fi

# Create directories
mkdir -p "Projects/Domain/$DOMAIN_NAME/Interface"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/API"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/DataSource"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/DTO"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/Entity"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/Repository"
mkdir -p "Projects/Domain/$DOMAIN_NAME/Sources/UseCase"

# Create Project.swift
cat <<EOF > "Projects/Domain/$DOMAIN_NAME/Project.swift"
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let configurations: [Configuration] = [
    .debug(name: .dev),
    .debug(name: .stage),
    .release(name: .prod)
]

let settings: Settings = .settings(
    base: env.baseSetting.merging(.codeSign),
    configurations: configurations,
    defaultSettings: .recommended
)

let interfaceTarget = Target.target(
    name: "${DOMAIN_NAME}Interface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\$(env.organizationName).${DOMAIN_NAME}Interface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib
    ]
)

let implementationTarget = Target.target(
    name: "${DOMAIN_NAME}",
    destinations: env.destination,
    product: .framework,
    bundleId: "\$(env.organizationName).${DOMAIN_NAME}",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "${DOMAIN_NAME}Interface"),
        .Projects.baseDomain,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "${DOMAIN_NAME}",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
EOF

# Create Interface file
cat <<EOF > "Projects/Domain/$DOMAIN_NAME/Interface/${DOMAIN_NAME}Interface.swift"
import Foundation

public protocol ${DOMAIN_NAME}Interface {}
EOF

# Create main Domain file in Sources
cat <<EOF > "Projects/Domain/$DOMAIN_NAME/Sources/${DOMAIN_NAME}.swift"
import Foundation

@_exported import ${DOMAIN_NAME}Interface

public struct ${DOMAIN_NAME} {
    public init() {}
}
EOF

# Create empty placeholder files in each directory
touch "Projects/Domain/$DOMAIN_NAME/Sources/API/.gitkeep"
touch "Projects/Domain/$DOMAIN_NAME/Sources/DataSource/.gitkeep"
touch "Projects/Domain/$DOMAIN_NAME/Sources/DTO/.gitkeep"
touch "Projects/Domain/$DOMAIN_NAME/Sources/Entity/.gitkeep"
touch "Projects/Domain/$DOMAIN_NAME/Sources/Repository/.gitkeep"
touch "Projects/Domain/$DOMAIN_NAME/Sources/UseCase/.gitkeep"

# Convert to lowerCamelCase
LOWER_CAMEL_CASE_NAME="$(tr '[:upper:]' '[:lower:]' <<< "${DOMAIN_NAME:0:1}")${DOMAIN_NAME:1}"

# Add to DependencyPlugin using Python script
python3 Scripts/add_to_dependency.py domain "$DOMAIN_NAME" "$LOWER_CAMEL_CASE_NAME"

# Add to Domain/Project.swift
sed -i '' "/.Projects.acceptDomain,/a\\
        .Projects.${LOWER_CAMEL_CASE_NAME}," Projects/Domain/Project.swift

# Add to App dependencies
sed -i '' "/.Projects.checkSelfStudyTeacherDomainInterface,/a\\
    .Projects.${LOWER_CAMEL_CASE_NAME},\\
    .Projects.${LOWER_CAMEL_CASE_NAME}Interface," Projects/App/Project.swift

echo "Domain '$DOMAIN_NAME' created successfully."
echo "Run 'tuist generate' to include it in the project."
