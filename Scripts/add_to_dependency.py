#!/usr/bin/env python3
import sys
import re

def add_domain_dependency(domain_name, lower_camel_name):
    file_path = "Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift"

    with open(file_path, 'r') as f:
        lines = f.readlines()

    # Find the position to insert (before the closing brace of Projects extension)
    insert_index = -1
    for i in range(len(lines) - 1, -1, -1):
        if 'checkSelfStudyTeacherDomainInterface' in lines[i]:
            # Find the next closing parenthesis
            for j in range(i, len(lines)):
                if lines[j].strip() == ')':
                    insert_index = j + 1
                    break
            break

    if insert_index == -1:
        print("Error: Could not find insertion point")
        sys.exit(1)

    # Create the new dependency lines with Interface
    new_lines = [
        f"    static let {lower_camel_name} = TargetDependency.project(\n",
        f"        target: \"{domain_name}\",\n",
        f"        path: .relativeToRoot(\"Projects/Domain/{domain_name}\")\n",
        f"    )\n",
        f"    static let {lower_camel_name}Interface = TargetDependency.project(\n",
        f"        target: \"{domain_name}Interface\",\n",
        f"        path: .relativeToRoot(\"Projects/Domain/{domain_name}\")\n",
        f"    )\n"
    ]

    # Insert the new lines
    lines[insert_index:insert_index] = new_lines

    with open(file_path, 'w') as f:
        f.writelines(lines)

    print(f"Added {domain_name} to DependencyPlugin")

def add_feature_dependency(feature_name, lower_camel_name):
    file_path = "Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift"

    with open(file_path, 'r') as f:
        lines = f.readlines()

    # Find the position to insert (before // other Module comment)
    insert_index = -1
    for i, line in enumerate(lines):
        if '// other Module' in line:
            insert_index = i
            break

    if insert_index == -1:
        print("Error: Could not find insertion point")
        sys.exit(1)

    # Create the new dependency lines
    new_lines = [
        f"    static let {lower_camel_name}Feature = TargetDependency.project(\n",
        f"        target: \"{feature_name}Feature\",\n",
        f"        path: .relativeToRoot(\"Projects/Feature/{feature_name}\")\n",
        f"    )\n",
        f"    static let {lower_camel_name}FeatureInterface = TargetDependency.project(\n",
        f"        target: \"{feature_name}FeatureInterface\",\n",
        f"        path: .relativeToRoot(\"Projects/Feature/{feature_name}\")\n",
        f"    )\n"
    ]

    # Insert the new lines
    lines[insert_index:insert_index] = new_lines

    with open(file_path, 'w') as f:
        f.writelines(lines)

    print(f"Added {feature_name} to DependencyPlugin")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: add_to_dependency.py <domain|feature> <Name> <lowerCamelName>")
        sys.exit(1)

    type_arg = sys.argv[1]
    name = sys.argv[2]
    lower_camel_name = sys.argv[3]

    if type_arg == "domain":
        add_domain_dependency(name, lower_camel_name)
    elif type_arg == "feature":
        add_feature_dependency(name, lower_camel_name)
    else:
        print("Error: type must be 'domain' or 'feature'")
        sys.exit(1)
