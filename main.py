import pyautogui
import time
import datetime
import logging
import argparse

# 配置默认值
DEFAULT_IDLE_THRESHOLD = 120
DEFAULT_LOOP_DELAY = 30
DEFAULT_MOVE_DISTANCE = 1
DEFAULT_WORK_START_TIME = '08:00'  # 工作开始时间：08:00
DEFAULT_WORK_END_TIME = '18:00'    # 工作结束时间：18:00
DEFAULT_LOG_LEVEL = 'INFO'

# 获取命令行参数
parser = argparse.ArgumentParser(description='Mouse idle script with configurable settings')
parser.add_argument('--idle_threshold', type=int, default=DEFAULT_IDLE_THRESHOLD,
                    help=f'Idle time threshold in seconds (default: {DEFAULT_IDLE_THRESHOLD})')
parser.add_argument('--move_distance', type=int, default=DEFAULT_MOVE_DISTANCE,
                    help=f'Distance to move the mouse in pixels (default: {DEFAULT_MOVE_DISTANCE})')
parser.add_argument('--loop_delay', type=int, default=DEFAULT_LOOP_DELAY,
                    help=f'Loop delay time in seconds (default: {DEFAULT_LOOP_DELAY})')
parser.add_argument('--work_start_time', type=str, default=DEFAULT_WORK_START_TIME,
                    help=f'Work start time in HH:MM format (default: {DEFAULT_WORK_START_TIME})')
parser.add_argument('--work_end_time', type=str, default=DEFAULT_WORK_END_TIME,
                    help=f'Work end time in HH:MM format (default: {DEFAULT_WORK_END_TIME})')
parser.add_argument('--log_level', type=str, default=DEFAULT_LOG_LEVEL,
                    choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'],
                    help=f'Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL) (default: {DEFAULT_LOG_LEVEL})')
args = parser.parse_args()

# 设置日志级别
logging.basicConfig(level=args.log_level, format='%(asctime)s - %(levelname)s - %(message)s')

# 解析工作时间范围参数
try:
    WORK_START_TIME = datetime.datetime.strptime(args.work_start_time, '%H:%M').time()
    WORK_END_TIME = datetime.datetime.strptime(args.work_end_time, '%H:%M').time()
except ValueError as e:
    logging.error(f"Invalid time format: {e}. Use HH:MM format for --work_start_time and --work_end_time.")
    exit(1)

logging.info(f"Script started with parameters: idle_threshold={args.idle_threshold}, "
             f"move_distance={args.move_distance}, loop_delay={args.loop_delay}, "
             f"work_start_time={WORK_START_TIME}, work_end_time={WORK_END_TIME}, log_level={args.log_level}")

# 初始滑鼠位置
last_mouse_x, last_mouse_y = pyautogui.position()

# 用来标记上一次滑鼠活动时间
last_active_time = time.time()

while True:
    # 获取当前滑鼠位置
    current_mouse_x, current_mouse_y = pyautogui.position()

    # 判断滑鼠是否移动
    if current_mouse_x != last_mouse_x or current_mouse_y != last_mouse_y:
        # 如果滑鼠移动了，更新滑鼠位置和上一次活动时间
        last_mouse_x, last_mouse_y = current_mouse_x, current_mouse_y
        last_active_time = time.time()
        logging.debug(f"Mouse moved to: ({current_mouse_x}, {current_mouse_y})")
    else:
        # 如果滑鼠未移动，检查空闲时间是否超过阈值并且当前时间是否在工作时间内
        current_time = datetime.datetime.now().time()
        if (time.time() - last_active_time >= args.idle_threshold and
                WORK_START_TIME <= current_time <= WORK_END_TIME):
            logging.debug(f"Mouse idle for {args.idle_threshold} seconds at: ({last_mouse_x}, {last_mouse_y})")

            # 移动滑鼠
            original_position = pyautogui.position()
            pyautogui.move(args.move_distance, 0, duration=0.25)
            pyautogui.moveTo(*original_position, duration=0.25)  # 恢复到原来的位置

            # 模拟键盘输入
            pyautogui.press('shift')

    # 等待循环等待时间，减少循环的频率
    time.sleep(args.loop_delay)
