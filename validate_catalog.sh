#!/bin/bash
# Simple catalog validation script

echo "=== Validating catalog.json ==="
if python3 -m json.tool catalog.json > /dev/null 2>&1; then
    echo "✓ catalog.json is valid JSON"
else
    echo "✗ catalog.json has JSON errors"
    python3 -m json.tool catalog.json
fi

echo -e "\n=== Checking app structure ==="
for train in community charts enterprise test; do
    if [ -d "$train" ]; then
        echo "Found train: $train"
        for app in $train/*/; do
            if [ -d "$app" ]; then
                app_name=$(basename "$app")
                echo "  Checking app: $app_name"
                
                # Check required files
                for file in "item.yaml" "app_versions.json"; do
                    if [ -f "$app$file" ]; then
                        echo "    ✓ $file exists"
                    else
                        echo "    ✗ $file missing"
                    fi
                done
                
                # Check version directories
                for version_dir in $app*/; do
                    if [ -d "$version_dir" ] && [[ $(basename "$version_dir") =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                        version=$(basename "$version_dir")
                        echo "    Version $version:"
                        for file in "Chart.yaml" "questions.yaml" "ix_values.yaml" "app-readme.md"; do
                            if [ -f "$version_dir$file" ]; then
                                echo "      ✓ $file exists"
                            else
                                echo "      ✗ $file missing"
                            fi
                        done
                    fi
                done
            fi
        done
    fi
done

echo -e "\n=== Checking catalog.json content ==="
python3 -c "
import json
with open('catalog.json', 'r') as f:
    catalog = json.load(f)
    for train, apps in catalog.items():
        print(f'Train: {train}')
        for app_name, app_data in apps.items():
            print(f'  App: {app_name}')
            required_fields = ['name', 'title', 'description', 'latest_version', 'location', 'last_update', 'maintainers']
            for field in required_fields:
                if field in app_data:
                    print(f'    ✓ {field}: {str(app_data[field])[:50]}...')
                else:
                    print(f'    ✗ {field}: MISSING')
"