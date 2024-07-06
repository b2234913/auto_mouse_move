## How to Install

1. For Linux and MacOS:
   - Run the following command in the terminal to download and execute the installation script:
     ```bash
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/b2234913/auto_mouse_move/main/install.sh)"
     ```

2. For Windows:
   - Download the [auto_mouse_move_for_windows.zip](https://github.com/b2234913/auto_mouse_move/releases/download/v1.0.0/auto_mouse_move_for_windows.zip) file.
   - Unzip and run the `auto_mouse_move.exe` file.

## How to Use

1. **Command Line Arguments:**
   - `--idle_threshold`: Idle time threshold in seconds (default: 120).
   - `--move_distance`: Distance to move the mouse in pixels (default: 1).
   - `--loop_delay`: Loop delay time in seconds (default: 30).
   - `--work_start_time`: Work start time in HH:MM format (default: '08:00').
   - `--work_end_time`: Work end time in HH:MM format (default: '18:00').
   - `--log_level`: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL) (default: 'INFO').

2. **Running the Script:**
   - Execute the script (`main.py`) from the command line with optional arguments.
   - Example: `python main.py --idle_threshold 60 --move_distance 2 --loop_delay 15 --work_start_time '09:00' --work_end_time '17:00' --log_level 'DEBUG'`

3. **Running the Binary:**
   - If you prefer not to run the script directly, binary files for Windows and MacOS are available in the `bin` folder.
   - Simply double-click the binary file to run the program with default settings.

4. **Script Operation:**
   - The script monitors mouse activity during work hours.
   - If the mouse remains idle for over the specified threshold, the script simulates a minor movement and a keystroke to avoid system idle status.
   - The script remains inactive outside of work hours.

## Personalization

- **Work Hours:** Adjust the `--work_start_time` and `--work_end_time` arguments to customize work hours.
- **Idle Duration:** Modify the `--idle_threshold` argument to set the idle duration (in seconds) before the script triggers mouse movement.
- **Movement Distance:** Alter the `--move_distance` argument to define the distance covered during idle prevention.
- **Log Level:** Set the `--log_level` argument to control the verbosity of the logs.

## Important Points

- The script employs the `pyautogui` Python package for mouse and keyboard manipulation.
- Make sure to install the `pyautogui` package using pip (`pip install pyautogui`) before running the script.
- The binary files were compiled using PyInstaller. If you wish to compile the script yourself, you can use the command `pyinstaller --onefile main.py`.