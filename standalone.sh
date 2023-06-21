set -e

if [ -z "$1" ]; then
  echo "No package specified"

  exit 1
fi

package="$1"
packages="$@"

# Shell script
prefix="$(cd "$(dirname "$0")" && pwd)"

# Executable shell script
#prefix="$(cd "$(dirname "$(realpath "$(which "$0")")")" && pwd)"

prep()
{
  if [ -f "${prefix}/hacks/${package}/additional.list" ]; then
    local additional="$(cat "${prefix}/hacks/${package}/additional.list")"
    packages="${packages} ${additional}"
    echo "[hack] Including additional packages (${additional})"
  fi

  #mkdir "${package}"
  mkdir -p "${package}/packages"
}

download()
{
  #export PKG_CACHE="${package}/packages"
  #pkg_add -n -z ${packages}
  #unset PKG_CACHE

  for pkg in ${packages}; do
    verify_fetch_package "${pkg}"
  done
}

verify_fetch_package()
{
  local name="$1"
  local installurl="$(cat "/etc/installurl")"
  local version="$(uname -r)"
  local arch="$(uname -p)"
  local suffix="tgz"

  local full=

  local pkgs="$(ftp -o- "${installurl}/${version}/packages/${arch}/index.txt" \
    | sed 's/^.* //g' \
    | grep ".${suffix}$" \
    | grep "^${name}-" \
    | sed "s/\.${suffix}//g" \
    | sort -r)"

  for pkg in ${pkgs}; do
    local trunk="$(echo $pkg | sed 's/-[0-9].*$//g')"

    if [ "${trunk}" = "${name}" ]; then
      full="${pkg}"
    fi
  done

  if [ -z "${full}" ]; then
    echo "[error] Failed to find package (${name})"
    exit 1
  fi

  echo "[info] Selecting package (${full})"

  fetch_package "${full}"
}

fetch_package()
{
  local name="$1"
  local installurl="$(cat "/etc/installurl")"
  local version="$(uname -r)"
  local arch="$(uname -p)"
  local suffix="tgz"

  if [ -f "${package}/packages/${name}.${suffix}" ]; then
    echo "[info] Package exists (${name}.${suffix})"
    return
  fi

  while true; do
    set +e
    ftp -o "${package}/packages/${name}.${suffix}" "${installurl}/${version}/packages/${arch}/${name}.${suffix}"
    local rc=$?
    set -e

    if [ $rc = 0 ]; then
      break
    fi

    echo "[warning] Failed to download, sleeping for retry"
    sleep 3
  done

  local deps="$(pkg_info -f "${package}/packages/${name}.${suffix}" | grep '^@depend ' | sed 's/^.*://')"

  for dep in ${deps}; do
    fetch_package "${dep}"
  done
}

extract()
{
  local pkgs="$(ls "${package}/packages")"

  for pkg in ${pkgs}; do
    tar -xzf "${package}/packages/${pkg}" -C "${package}"
  done

  rm -f "${package}/+CONTENTS"
  rm -f "${package}/+DESC"
  rm -f "${package}/+DISPLAY"
  rm -f "${package}/+UNDISPLAY"
  rm -r "${package}/packages"
}

wrappers()
{
  if [ -d "${prefix}/hacks/${package}" ]; then
    local files="$(cd "${prefix}/hacks/${package}" && ls | grep -v \.list$ | grep -v \.sh$)"

    for file in ${files}; do
      echo "[hack] Adding wrapper script (${file})"
      cat "${prefix}/hacks/wrapper_pre.template" > "${package}/${file}"
      cat "${prefix}/hacks/${package}/${file}" >> "${package}/${file}"
      cat "${prefix}/hacks/wrapper_post.template" >> "${package}/${file}"
      chmod +x "${package}/${file}"
    done
  else
    echo "[hack] Adding wrapper script (${package})"
    cat "${prefix}/hacks/wrapper_pre.template" > "${package}/${package}"
    echo "exec ${package} " '"$@"' >> "${package}/${package}"
    cat "${prefix}/hacks/wrapper_post.template" >> "${package}/${package}"
    chmod +x "${package}/${package}"
  fi
}

post()
{
  local script="${prefix}/hacks/${package}/post.sh"

  cat "${prefix}/hacks/post.template" > "${package}/post_install"
  echo "standalone_prefix=\"${prefix}\"" >> "${package}/post_install"

  if [ -f "${script}" ]; then
    cat "${script}" >> "${package}/post_install"
  fi

  echo "[hack] Running post script (${script})"
  chmod +x "${package}/post_install"
  "${package}/post_install"
  rm "${package}/post_install"
}

prep
download
extract
wrappers
post

