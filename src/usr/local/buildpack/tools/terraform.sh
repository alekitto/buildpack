#!/bin/bash

set -e

check_semver "${TOOL_VERSION}"


if [[ ! "${MAJOR}" || ! "${MINOR}" || ! "${PATCH}" ]]; then
  echo Invalid version: "${TOOL_VERSION}"
  exit 1
fi

tool_path=$(find_versioned_tool_path)

if [[ -z "${tool_path}" ]]; then
  INSTALL_DIR=$(get_install_dir)
  base_path=${INSTALL_DIR}/${TOOL_NAME}
  tool_path=${base_path}/${TOOL_VERSION}

  mkdir -p "${tool_path}/bin"

  file=/tmp/${TOOL_NAME}.tgz

  DISTRO=linux_$(uname -m)
  if [ "$DISTRO" == "linux_x86_64" ]; then
    DISTRO="linux_amd64"
  elif [ "$DISTRO" == "linux-aarch64" ]; then
    DISTRO="linux_arm64"
  fi

  curl -sSfLo "${file}" "https://releases.hashicorp.com/terraform/${TOOL_VERSION}/terraform_${TOOL_VERSION}_${DISTRO}.zip"
  unzip -q -d "${tool_path}/bin" "${file}"
  rm "${file}"
fi

link_wrapper "${TOOL_NAME}" "${tool_path}/bin"

terraform version
