#!/bin/bash
set -e
whereami="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
vnet_path="$( cd $whereami/../.. && pwd )"
etc_path=$vnet_path/deployment/conf_files/etc

pkg_format="rpm"
pkg_epoch=0

pkg_output_dir=$vnet_path/packages/$pkg_format
pkg_to_build=$1

fpm_path=$vnet_path/ruby/bin/fpm

# Resets all package metadata to present leftovers from a previously sourced package
function flush_package_meta() {
  pkg_name=""
  pkg_desc=""
  pkg_deps=""
  pkg_arch=""
  pkg_dirs=""
  pkg_cfgs=""
  pkg_owned_dirs=""
}

function build_package() {
  local pkg_meta_file=$1

  flush_package_meta
  . ${whereami}/packages.d/$pkg_meta_file

  echo "building $pkg_format package: $pkg_name"

  if [ -z "$pkg_dirs" ]; then
    pkg_src=empty
  else
    pkg_src=dir
  fi
  if [ -z "$pkg_deps" ]; then pkg_deps_string=""; else pkg_deps_string="--depends ${pkg_deps//\ / -d }"; fi
  if [ -z "$pkg_cfgs" ]; then pkg_cfgs_string=""; else pkg_cfgs_string="--config-files ${pkg_cfgs//$'\n'/ --config-files }"; fi
  if [ -z "$pkg_owned_dirs" ]; then pkg_own_string=""; else pkg_own_string="--directories ${pkg_owned_dirs//$'\n'/ --directories }"; fi

  $fpm_path -s $pkg_src -t $pkg_format -n $pkg_name -p $pkg_output_dir \
    ${pkg_deps_string} \
    ${pkg_cfgs_string} \
    ${pkg_own_string} \
    --epoch $pkg_epoch \
    --description "${pkg_desc}" \
    --architecture $pkg_arch \
    $pkg_dirs
}

mkdir -p $pkg_output_dir
if [ -z "$pkg_to_build" ]; then
  for pkg_meta_file in `ls ${whereami}/packages.d/`; do
    build_package $pkg_meta_file
  done
else
  build_package "$pkg_to_build.meta"
fi
