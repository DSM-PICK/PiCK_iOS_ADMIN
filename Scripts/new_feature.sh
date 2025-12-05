#!/bin/sh

FEATURE_NAME=$1

if [ -z "$FEATURE_NAME" ]; then
  echo "Usage: $0 <feature-name>"
  exit 1
fi

# Confirm with user
echo "Creating feature: $FEATURE_NAME"
read -p "Is this correct? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Cancelled."
  exit 0
fi

# Create directories
mkdir -p "Projects/Feature/$FEATURE_NAME/Interface"
mkdir -p "Projects/Feature/$FEATURE_NAME/Sources"
mkdir -p "Projects/Feature/$FEATURE_NAME/Tests"

# Create Project.swift
cat <<EOF > "Projects/Feature/$FEATURE_NAME/Project.swift"
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
    name: "${FEATURE_NAME}FeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\$(env.organizationName).${FEATURE_NAME}FeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "${FEATURE_NAME}Feature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\$(env.organizationName).${FEATURE_NAME}Feature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "${FEATURE_NAME}FeatureInterface"),
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let project = Project(
    name: "${FEATURE_NAME}Feature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
EOF

# Create Interface file
cat <<EOF > "Projects/Feature/$FEATURE_NAME/Interface/${FEATURE_NAME}Interface.swift"
import Foundation

public protocol ${FEATURE_NAME}Interface {
    
}
EOF

# Create Source file
cat <<EOF > "Projects/Feature/$FEATURE_NAME/Sources/${FEATURE_NAME}.swift"
import Foundation

public class ${FEATURE_NAME} {
    
}
EOF

# Create Test file
cat <<EOF > "Projects/Feature/$FEATURE_NAME/Tests/${FEATURE_NAME}Tests.swift"
import XCTest

final class ${FEATURE_NAME}Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue(true)
    }

}
EOF

# Convert to lowerCamelCase
LOWER_CAMEL_CASE_FEATURE_NAME="$(tr '[:upper:]' '[:lower:]' <<< "${FEATURE_NAME:0:1}")${FEATURE_NAME:1}"

# Add to DependencyPlugin using Python script
python3 Scripts/add_to_dependency.py feature "$FEATURE_NAME" "$LOWER_CAMEL_CASE_FEATURE_NAME"

# Add to app dependencies
sed -i '' "/.Features.acceptFeatureInterface,/a\\
    .Features.${LOWER_CAMEL_CASE_FEATURE_NAME}Feature,\\
    .Features.${LOWER_CAMEL_CASE_FEATURE_NAME}FeatureInterface," Projects/App/Project.swift

echo "Feature '$FEATURE_NAME' created successfully."
echo "Run 'tuist generate' to include it in the project."