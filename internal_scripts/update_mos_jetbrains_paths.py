import json
import plistlib
import subprocess

from __jetbrains import JETBRAINS_APP_TO_PATH_MAPPING

MOS_DOMAIN = 'com.caldis.Mos'


def read_mos_options() -> dict:
    options: dict = plistlib.loads(
        subprocess.run(['defaults', 'export', MOS_DOMAIN, '-'], capture_output=True).stdout
    )
    return options


def write_mos_options(options: dict):
    subprocess.run(['defaults', 'import', MOS_DOMAIN, '-'], input=plistlib.dumps(options))


def exit_mos():
    subprocess.run(['osascript', '-e', f'quit app id "{MOS_DOMAIN}"'])


def launch_mos():
    subprocess.run(['open', '-b', MOS_DOMAIN])


def sync_mos_options_with_jetbrains_paths(mos_options: dict, jetbrains_app_to_path_mapping: dict[str, str]):
    applications = json.loads(mos_options['applications'])
    for app in applications:
        app_name = app['path'].split('/')[-1]
        if app_name in jetbrains_app_to_path_mapping:
            app['path'] = jetbrains_app_to_path_mapping[app_name]
    mos_options['applications'] = json.dumps(applications, ensure_ascii=False).encode()


def main():
    exit_mos()
    mos_options = read_mos_options()
    sync_mos_options_with_jetbrains_paths(mos_options, JETBRAINS_APP_TO_PATH_MAPPING)
    write_mos_options(mos_options)
    launch_mos()


if __name__ == '__main__':
    main()
