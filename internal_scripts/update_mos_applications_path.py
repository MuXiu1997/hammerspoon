import json
import os
import plistlib
import subprocess
from pathlib import Path

MOS_DOMAIN = 'com.caldis.Mos'
JETBRAINS_BIN_DIR = Path(os.environ['JETBRAINS_BIN'])


def read_options() -> dict:
    options = plistlib.loads(subprocess.run(['defaults', 'export', MOS_DOMAIN, '-'], capture_output=True).stdout)
    return options


def write_options(options: dict):
    subprocess.run(['defaults', 'import', MOS_DOMAIN, '-'], input=plistlib.dumps(options))


def exit_mos():
    subprocess.run(['osascript', '-e', f'quit app id "{MOS_DOMAIN}"'])


def launch_mos():
    subprocess.run(['open', '-b', MOS_DOMAIN])


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


def update_mos_applications_path(options: dict, jetbrains_paths: dict[str, str]):
    applications = json.loads(options['applications'])
    for app in applications:
        app_name = app['path'].split('/')[-1]
        if app_name in jetbrains_paths:
            app['path'] = jetbrains_paths[app_name]
    options['applications'] = json.dumps(applications, ensure_ascii=False).encode()


def main():
    exit_mos()
    options = read_options()
    jetbrains_paths = build_jetbrains_paths()
    update_mos_applications_path(options, jetbrains_paths)
    write_options(options)
    launch_mos()


if __name__ == '__main__':
    main()
