# gcx: switch gcloud configuration AND Application Default Credentials, per shell.
#
#   gcx            list configurations; show this shell's
#   gcx <name>     use <name> in this shell (gcloud, client libraries, Pulumi)
#   gcx -          back to the global gcloud config and default ADC
#   gcx-login <n>  (re)create <n>'s gcloud login and its own ADC file
#
# ADC per configuration lives in ~/.config/gcloud/adc/<name>.json.
# `gcloud auth application-default login` always writes the one shared
# application_default_credentials.json; gcx-login copies it from there.

typeset -g GCX_ADC_DIR=~/.config/gcloud/adc
# Print a URL to open in any browser and paste the code back, instead of
# launching one here. Set to "" to launch a local browser, or "--no-browser"
# to finish on another machine that has gcloud.
: ${GCX_LOGIN_FLAGS=--no-launch-browser}
typeset -g GCX_CONF_DIR=~/.config/gcloud/configurations

# Read a core property from a configuration file without starting gcloud.
_gcx_prop() {
  sed -n "s/^$2[[:space:]]*=[[:space:]]*//p" "$GCX_CONF_DIR/config_$1" | head -1
}

gcx() {
  if [[ -z $1 ]]; then
    gcloud config configurations list
    print "shell: ${CLOUDSDK_ACTIVE_CONFIG_NAME:-<global>}  ADC: ${GOOGLE_APPLICATION_CREDENTIALS:-<default>}"
    return
  fi
  if [[ $1 == - ]]; then
    unset CLOUDSDK_ACTIVE_CONFIG_NAME GOOGLE_APPLICATION_CREDENTIALS GOOGLE_CLOUD_PROJECT
    return
  fi
  if [[ ! -f $GCX_CONF_DIR/config_$1 ]]; then
    print -u2 "gcx: no configuration '$1'"; return 1
  fi
  export CLOUDSDK_ACTIVE_CONFIG_NAME=$1
  export GOOGLE_CLOUD_PROJECT=$(_gcx_prop $1 project)
  if [[ -f $GCX_ADC_DIR/$1.json ]]; then
    export GOOGLE_APPLICATION_CREDENTIALS=$GCX_ADC_DIR/$1.json
  else
    # Never fall through to another account's ADC.
    unset GOOGLE_APPLICATION_CREDENTIALS
    print -u2 "gcx: no ADC for '$1' (client libraries/Pulumi will use the default file); run: gcx-login $1"
  fi
}

gcx-login() {
  local name=$1
  if [[ -z $name || ! -f $GCX_CONF_DIR/config_$name ]]; then
    print -u2 "usage: gcx-login <configuration>"; return 1
  fi
  local account=$(_gcx_prop $name account)
  print "Logging in $account for '$name'. Sign in as $account."
  # One sign-in for both: --update-adc writes the shared ADC file from it.
  # --force: a fresh web sign-in, not a password reauth of a stored login
  # (which can't satisfy a security-key requirement).
  CLOUDSDK_ACTIVE_CONFIG_NAME=$name gcloud auth login "$account" --force --update-adc ${=GCX_LOGIN_FLAGS} || return

  # No account check needed: `gcloud auth login ACCOUNT` fails if you sign in
  # as anyone else, and --update-adc writes those same credentials. (A check
  # that refreshed the token would cost a second reauth prompt.)
  local src=~/.config/gcloud/application_default_credentials.json
  mkdir -p -m 700 $GCX_ADC_DIR
  install -m 600 $src $GCX_ADC_DIR/$name.json
  print "Saved $GCX_ADC_DIR/$name.json"
  gcx $name
}

_gcx() { compadd -- - ${${(f)"$(print -l $GCX_CONF_DIR/config_*(N:t))"}#config_} }
compdef _gcx gcx gcx-login
