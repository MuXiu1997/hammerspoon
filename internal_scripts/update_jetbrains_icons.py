import os
import subprocess
from pathlib import Path

JETBRAINS_BIN_DIR = Path(os.environ['JETBRAINS_BIN'])
ICONS_DIR = Path(os.path.expanduser('~/Projects/JetBrains-Icons'))
ICONS_MAP = {
    'goland': 'JetBrains GoLand.icns',
    'idea': 'JetBrains Inteliij IDEA.icns',
    'pycharm': 'JetBrains PyCharm.icns',
    'webstorm': 'JetBrains WebStorm.icns',
}


def get_app_path_from_script(script_path: Path) -> str:
    with script_path.open() as fp:
        for line in fp:
            if line.startswith('open '):
                return line.split('"')[1]


def build_jetbrains_paths() -> dict[str, str]:
    jetbrains_path_dir = {}
    for script in JETBRAINS_BIN_DIR.glob('./*'):
        app_path = get_app_path_from_script(script)
        app_name = app_path.split('/')[-1]
        jetbrains_path_dir[app_name] = app_path
    return jetbrains_path_dir


def update_jetbrains_icons(jetbrains_paths: dict[str, str]):
    for app_name, app_path in jetbrains_paths.items():
        dot_app_path = '/'.join(app_path.split('/')[:-3])
        icon_path = ICONS_DIR / ICONS_MAP[app_name]
        subprocess.run(['fileicon', 'set', dot_app_path, icon_path])


def restart_dock():
    subprocess.run(['killall', 'Dock'])


def main():
    jetbrains_paths = build_jetbrains_paths()
    update_jetbrains_icons(jetbrains_paths)
    restart_dock()


if __name__ == '__main__':
    main()
