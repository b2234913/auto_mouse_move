#!/bin/bash

function download_and_install() {
  local zip_file="auto_mouse_move_for_linux.zip"
  local install_dir="/usr/local/bin"
  local zip_url="https://github.com/b2234913/auto_mouse_move/releases/download/v1.0.1/$zip_file"

  echo "Downloading $zip_file from $zip_url..."
  curl -L "$zip_url" --output "/tmp/$zip_file"

  echo "Installing to $install_dir..."
  unzip -o "/tmp/$zip_file" -d "$install_dir"
  sudo chmod -R 777 "$install_dir/auto_mouse_move"

  echo "Installation complete. Cleaning up..."
  rm "/tmp/$zip_file"
}

download_and_install