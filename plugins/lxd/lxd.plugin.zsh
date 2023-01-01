autoload -U +X bashcompinit && bashcompinit

_lxd_complete()
{
  _lxd_names()
  {
    COMPREPLY=( $( compgen -W \
      "$( lxc list --fast | tail -n +4 | awk '{print $2}' | grep -E -v '^(\||^$)' ) $1" "$cur" )
    )
  }

  _lxd_images()
  {
    COMPREPLY=( $( compgen -W \
      "$( lxc image list | tail -n +4 | awk '{print $2}' | grep -E -v '^(\||^$)' )" "$cur" )
    )
  }

  _lxd_remotes()
  {
    COMPREPLY=( $( compgen -W \
      "$( lxc remote list | tail -n +4 | awk '{print $2}' | grep -E -v '^(\||^$)' )" "$cur" )
    )
  }

  _lxd_profiles()
  {
    COMPREPLY=( $( compgen -W "$( lxc profile list )" "$cur" ) )
  }

  COMPREPLY=()
  # ignore special --foo args
  if [[ ${COMP_WORDS[COMP_CWORD]} == -* ]]; then
    return 0
  fi

  lxc_cmds="config copy delete exec file help image info init launch \
    list move profile publish remote restart restore snapshot start stop \
    version"

  global_keys="core.https_address core.https_allowd_origin \
    core.https_allowed_methods core.https_allowed_headers  \
    core.https_allowed_credentials core.proxy_https \
    core.proxy_http core.proxy_ignore_host core.trust_password \
    storage.lvm_vg_name storage.lvm_thinpool_name storage.lvm_fstype \
    storage.lvm_volume_size storage.lvm_mount_options storage.zfs_pool_name \
    storage.zfs_remove_snapshots storage.zfs_use_refquota \
    images.compression_algorithm \
    images.remote_cache_expiry images.auto_update_interval \
    images.auto_update_cached"

  container_keys="boot.autostart boot.autostart.delay boot.autostart.priority \
    boot.host_shutdown_timeout limits.cpu limits.cpu.allowance limits.cpu.priority \
    limits.disk.priority limits.memory limits.memory.enforce limits.memory.swap \
    limits.memory.swap.priority limits.network.priority limits.processes \
    linux.kernel_modules raw.apparmor raw.lxc raw.seccomp security.nesting \
    security.privileged security.syscalls.blacklist_default \
    security.syscalls.blacklist_compat security.syscalls.blacklist \
    security.syscalls.whitelist volatile.apply_template volatile.base_image \
    volatile.last_state.idmap volatile.last_state.power user.network_mode \
    user.meta-data user.user-data user.vendor-data"

  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$lxc_cmds" -- ${COMP_WORDS[COMP_CWORD]}) )
    return 0
  fi

  local no_dashargs
  cur=${COMP_WORDS[COMP_CWORD]}

  no_dashargs=(${COMP_WORDS[@]//-*})
  pos=$((COMP_CWORD - (${#COMP_WORDS[@]} - ${#no_dashargs[@]})))
  if [ -z "$cur" ]; then
    pos=$(($pos + 1))
  fi

  case ${no_dashargs[1]} in
    "config")
      case $pos in
        2)
          COMPREPLY=( $(compgen -W "device edit get set show trust" -- $cur) )
          ;;
        3)
          case ${no_dashargs[2]} in
            "trust")
              COMPREPLY=( $(compgen -W "list add remove" -- $cur) )
              ;;
            "device")
              COMPREPLY=( $(compgen -W "add get set unset list show remove" -- $cur) )
              ;;
            "show"|"edit")
              _lxd_names
              ;;
            "get"|"set"|"unset")
              _lxd_names "$global_keys"
              ;;
          esac
          ;;
        4)
          case ${no_dashargs[2]} in
            "trust")
              _lxd_remotes
              ;;
            "device")
              _lxd_names
              ;;
            "get"|"set"|"unset")
              COMPREPLY=( $(compgen -W "$container_keys" -- $cur) )
              ;;
          esac
          ;;
      esac
      ;;
    "copy")
      if [ $pos -lt 4 ]; then
        _lxd_names
      fi
      ;;
    "delete")
      _lxd_names
      ;;
    "exec")
      _lxd_names
      ;;
    "file")
      COMPREPLY=( $(compgen -W "pull push edit" -- $cur) )
      ;;
    "help")
      COMPREPLY=( $(compgen -W "$lxc_cmds" -- $cur) )
      ;;
    "image")
      COMPREPLY=( $(compgen -W "import copy delete edit export info list show alias" -- $cur) )
      ;;
    "info")
      _lxd_names
      ;;
    "init")
      _lxd_images
      ;;
    "launch")
      _lxd_images
      ;;
    "move")
      _lxd_names
      ;;
    "profile")
      case $pos in
        2)
          COMPREPLY=( $(compgen -W "list copy delete apply device edit get set show" -- $cur) )
          ;;
        3)
          case ${no_dashargs[2]} in
            "device")
              COMPREPLY=( $(compgen -W "add get set unset list show remove" -- $cur) )
              ;;
            *)
              _lxd_profiles
              ;;
          esac
          ;;
        4)
          case ${no_dashargs[2]} in
            "device")
              _lxd_profiles
              ;;
            *)
              COMPREPLY=( $(compgen -W "$container_keys" -- $cur) )
              ;;
          esac
          ;;
      esac
      ;;
    "publish")
      _lxd_names
      ;;
    "remote")
      COMPREPLY=( $(compgen -W \
        "add remove list rename set-url set-default get-default" -- $cur) )
      ;;
    "restart")
      _lxd_names
      ;;
    "restore")
      _lxd_names
      ;;
    "snapshot")
      _lxd_names
      ;;
    "start")
      # should check if containers are stopped
      _lxd_names
      ;;
    "stop")
      # should check if containers are started
      _lxd_names
      ;;
    *)
      ;;
  esac

  return 0
}

complete -o default -F _lxd_complete lxc
