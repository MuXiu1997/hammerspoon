import os
import subprocess
from pathlib import Path

from __jetbrains import JETBRAINS_APP_TO_PATH_MAPPING

ICONS_DIR = Path(os.path.expanduser('~/Projects/JetBrains-Icons'))

APP_TO_ICON_MAPPING = {
    'goland': 'JetBrains GoLand.icns',
    'idea': 'JetBrains Inteliij IDEA.icns',
    'pycharm': 'JetBrains PyCharm.icns',
    'webstorm': 'JetBrains WebStorm.icns',
}


def assign_icons_to_jetbrains_apps(jetbrains_app_to_path_mapping: dict[str, str]):
    for app_name, app_path in jetbrains_app_to_path_mapping.items():
        dot_app_path = '/'.join(app_path.split('/')[:-3])
        icon_path = ICONS_DIR / APP_TO_ICON_MAPPING.get(app_name, '')
        subprocess.run(['fileicon', 'set', dot_app_path, icon_path])


def refresh_dock():
    subprocess.run(['killall', 'Dock'])


def main():
    assign_icons_to_jetbrains_apps(JETBRAINS_APP_TO_PATH_MAPPING)
    refresh_dock()


if __name__ == '__main__':
    main()
