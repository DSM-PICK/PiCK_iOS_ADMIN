#!/bin/bash

echo "🔍 Searching for modules..."
echo ""

# Collect all modules
declare -a modules
declare -a module_paths
declare -a module_types

# Find Feature modules (excluding BaseFeature)
for dir in Projects/Feature/*/; do
    if [ -d "$dir" ]; then
        module_name=$(basename "$dir")
        if [ "$module_name" != "BaseFeature" ]; then
            modules+=("$module_name")
            module_paths+=("$dir")
            module_types+=("Feature")
        fi
    fi
done

# Find Domain modules (excluding BaseDomain and Core)
for dir in Projects/Domain/*/; do
    if [ -d "$dir" ]; then
        module_name=$(basename "$dir")
        if [ "$module_name" != "BaseDomain" ] && [ "$module_name" != "Core" ]; then
            modules+=("$module_name")
            module_paths+=("$dir")
            module_types+=("Domain")
        fi
    fi
done

if [ ${#modules[@]} -eq 0 ]; then
    echo "❌ No modules found to delete."
    exit 0
fi

# Display modules
echo "📦 Available modules:"
echo ""
for i in "${!modules[@]}"; do
    echo "  $((i+1)). [${module_types[$i]}] ${modules[$i]}"
done
echo ""

# Get user selection
read -p "Select module number to delete (or 'q' to quit): " selection

if [ "$selection" = "q" ] || [ "$selection" = "Q" ]; then
    echo "👋 Cancelled."
    exit 0
fi

# Validate selection
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#modules[@]} ]; then
    echo "❌ Invalid selection."
    exit 1
fi

# Get selected module info
index=$((selection-1))
module_name="${modules[$index]}"
module_path="${module_paths[$index]}"
module_type="${module_types[$index]}"

echo ""
echo "⚠️  You are about to delete: [$module_type] $module_name"
echo "   Path: $module_path"
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "👋 Cancelled."
    exit 0
fi

echo ""
echo "🗑️  Deleting module..."

# Delete the module directory
rm -rf "$module_path"
echo "✓ Deleted directory: $module_path"

# Remove from Dependency+Project.swift
if [ "$module_type" = "Feature" ]; then
    # Remove feature dependencies
    feature_var=$(echo "$module_name" | sed 's/Feature$//')
    lower_camel_case="$(tr '[:upper:]' '[:lower:]' <<< "${feature_var:0:1}")${feature_var:1}"

    # Remove the feature and interface entries
    sed -i '' "/static let ${lower_camel_case}Feature = TargetDependency.project/,/^    )/d" \
        Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift
    sed -i '' "/static let ${lower_camel_case}FeatureInterface = TargetDependency.project/,/^    )/d" \
        Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift

    echo "✓ Removed from Dependency+Project.swift"

    # Remove from App/Project.swift
    sed -i '' "/.Features.${lower_camel_case}Feature,/d" Projects/App/Project.swift
    sed -i '' "/.Features.${lower_camel_case}FeatureInterface,/d" Projects/App/Project.swift

    echo "✓ Removed from App/Project.swift"

elif [ "$module_type" = "Domain" ]; then
    # Remove domain dependencies
    domain_name="$module_name"
    lower_camel_case="$(tr '[:upper:]' '[:lower:]' <<< "${domain_name:0:1}")${domain_name:1}"

    # Remove the domain and interface entries
    sed -i '' "/static let ${lower_camel_case} = TargetDependency.project/,/^    )/d" \
        Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift
    sed -i '' "/static let ${lower_camel_case}Interface = TargetDependency.project/,/^    )/d" \
        Tuist/Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Project.swift

    echo "✓ Removed from Dependency+Project.swift"

    # Remove from App/Project.swift
    sed -i '' "/.Projects.${lower_camel_case},/d" Projects/App/Project.swift
    sed -i '' "/.Projects.${lower_camel_case}Interface,/d" Projects/App/Project.swift

    echo "✓ Removed from App/Project.swift"

    # Remove from Domain/Project.swift if exists
    if [ -f "Projects/Domain/Project.swift" ]; then
        sed -i '' "/.Projects.${lower_camel_case},/d" Projects/Domain/Project.swift
        echo "✓ Removed from Domain/Project.swift"
    fi
fi

echo ""
echo "✅ Module '$module_name' has been deleted successfully!"
echo "   Run 'make regenerate' to update your Xcode project."
