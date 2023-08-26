import os
from pathlib import Path

JETBRAINS_BIN_DIR: Path = Path(os.environ['JETBRAINS_BIN'])


def extract_app_path_from_script(script_file: Path) -> str:
    with script_file.open() as file_handle:
        for line in file_handle:
            if line.startswith('open '):
                return line.split('"')[1]


def map_jetbrains_apps_to_paths() -> dict[str, str]:
    app_to_path_mapping = {}
    for script in JETBRAINS_BIN_DIR.glob('./*'):
        app_path = extract_app_path_from_script(script)
        app_name = app_path.split('/')[-1]
        app_to_path_mapping[app_name] = app_path
    return app_to_path_mapping


JETBRAINS_APP_TO_PATH_MAPPING = map_jetbrains_apps_to_paths()

__all__ = ['JETBRAINS_APP_TO_PATH_MAPPING']
