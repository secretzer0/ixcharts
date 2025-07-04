#!/usr/bin/env python3
"""
Simple script to generate catalog.json from the app structure.
This mimics what the official catalog_update tool does.
"""

import json
import os
import datetime
from pathlib import Path

def generate_catalog():
    catalog = {}
    base_path = Path(__file__).parent
    
    # Scan for trains (top-level directories)
    for train_dir in base_path.iterdir():
        if not train_dir.is_dir() or train_dir.name.startswith('.'):
            continue
        
        train_name = train_dir.name
        if train_name in ['community', 'charts', 'enterprise', 'test']:
            catalog[train_name] = {}
            
            # Scan for apps in this train
            for app_dir in train_dir.iterdir():
                if not app_dir.is_dir():
                    continue
                
                app_name = app_dir.name
                
                # Read item.yaml
                item_path = app_dir / 'item.yaml'
                if not item_path.exists():
                    continue
                
                # Read app_versions.json
                versions_path = app_dir / 'app_versions.json'
                if not versions_path.exists():
                    continue
                
                with open(versions_path, 'r') as f:
                    versions = json.load(f)
                
                # Find latest version
                latest_version = None
                latest_app_version = None
                for version, info in versions.items():
                    if info.get('healthy', False):
                        latest_version = version
                        # Try to get app version from Chart.yaml
                        chart_path = app_dir / version / 'Chart.yaml'
                        if chart_path.exists():
                            import yaml
                            with open(chart_path, 'r') as f:
                                chart = yaml.safe_load(f)
                                latest_app_version = chart.get('appVersion', version)
                        break
                
                if not latest_version:
                    continue
                
                # Read app-readme.md
                readme_path = app_dir / latest_version / 'app-readme.md'
                app_readme = ""
                if readme_path.exists():
                    with open(readme_path, 'r') as f:
                        content = f.read()
                        # Convert to HTML-like format
                        app_readme = content.replace('\n', '\\n')
                
                # Build app entry
                catalog[train_name][app_name] = {
                    "app_readme": app_readme,
                    "categories": ["media", "tools"],  # You'd parse this from item.yaml
                    "description": "A comprehensive media transcoding and subtitle processing toolkit",
                    "healthy": True,
                    "healthy_error": None,
                    "home": "https://github.com/secretzer0/ixcharts",
                    "location": f"{train_name}/{app_name}",
                    "latest_version": latest_version,
                    "latest_app_version": latest_app_version or latest_version,
                    "latest_human_version": f"{latest_app_version or latest_version}_{latest_version}",
                    "last_update": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    "name": app_name,
                    "recommended": False,
                    "title": app_name.title(),
                    "maintainers": [
                        {
                            "name": "secretzer0",
                            "url": "https://github.com/secretzer0",
                            "email": "noreply@example.com"
                        }
                    ],
                    "tags": ["transcoding", "ffmpeg", "subtitle", "ocr", "media-processing"],
                    "screenshots": [],
                    "sources": [
                        "https://github.com/secretzer0/ixcharts",
                        "https://ffmpeg.org/",
                        "https://mkvtoolnix.download/"
                    ],
                    "icon_url": f"https://raw.githubusercontent.com/secretzer0/ixcharts/main/{train_name}/{app_name}/icon.png"
                }
    
    # Write catalog.json
    with open(base_path / 'catalog.json', 'w') as f:
        json.dump(catalog, f, indent=4)
    
    print("catalog.json generated successfully!")

if __name__ == "__main__":
    generate_catalog()