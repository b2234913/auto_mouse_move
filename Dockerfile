# 使用 Windows Server Core LTSC 2022 镜像
FROM python:windowsservercore-ltsc2022

# 设置工作目录
WORKDIR /src

# 安装 PyInstaller
RUN python -m pip install pyinstaller

# 复制当前目录下的所有内容到容器中的工作目录
COPY . .

# 运行 PyInstaller 以打包可执行文件
ENTRYPOINT ["pyinstaller"]
CMD ["--onefile", "main.py"]
