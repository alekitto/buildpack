#!/bin/bash

function install_tool () {
  local versioned_tool_path
  versioned_tool_path=$(create_versioned_tool_path)

  local file
  local ARCH=$(uname -m)
  if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
  elif [ "$ARCH" == "linux-aarch64" ]; then
    ARCH="arm64"
  fi

  file=$(get_from_url "https://github.com/fluxcd/flux2/releases/download/v${TOOL_VERSION}/flux_${TOOL_VERSION}_linux_${ARCH}.tar.gz")
  tar -C "${versioned_tool_path}" -zxvf "${file}"
}

function link_tool () {
  local versioned_tool_path
  versioned_tool_path=$(find_versioned_tool_path)

  shell_wrapper "${TOOL_NAME}" "${versioned_tool_path}"
  flux -v
}
