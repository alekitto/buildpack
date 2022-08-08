#!/bin/bash

function install_tool () {
  local versioned_tool_path
  versioned_tool_path=$(create_versioned_tool_path)

  ARCH=$(uname -m)
  if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
  elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
  fi

  create_folder "${versioned_tool_path}/bin"

  local file
  file=$(get_from_url "https://get.helm.sh/helm-v${TOOL_VERSION}-linux-${ARCH}.tar.gz")
  tar --strip 1 -C "${versioned_tool_path}/bin" -xf "${file}"
}

function link_tool () {
  local versioned_tool_path
  versioned_tool_path=$(find_versioned_tool_path)

  shell_wrapper "${TOOL_NAME}" "${versioned_tool_path}/bin"
  helm version
}
