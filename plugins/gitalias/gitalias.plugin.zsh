gitalias() {
  local the_type
  the_type=$(type "$LBUFFER")

  if [[ $the_type =~ 'alias for git' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}

zle -N gitalias

# space expands all aliases, including global
bindkey -M emacs " " gitalias
bindkey -M viins " " gitalias

# control-space to make a normal space
bindkey -M emacs "^ " magic-space
bindkey -M viins "^ " magic-space

# normal space during searches
bindkey -M isearch " " magic-space
