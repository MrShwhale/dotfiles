from typing import List
from kitty.boss import Boss

KITTY_CONF = "~/.config/kitty/"
BACKGROUND_IMAGE = "~/Documents/Development/Python/hyperToKitty/waifus/miku.png"

def main(args: List[str]) -> str:
    return args[1]

def handle_result(args: List[str], turn_on: str, target_window_id: int, boss: Boss) -> None:
    bool_on = turn_on == 'on'
    # get the kitty window into which to paste answer
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        boss.call_remote_control(w, ('set-background-image', '--all', 'none' if bool_on else BACKGROUND_IMAGE))
