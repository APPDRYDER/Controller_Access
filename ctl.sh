#!/bin/bash
#
#
# Required environment Variables:
#   APPD_CONTROLLER_INSTALL_DIR
#   APPD_DB_PWD
#   APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
#   APPDYNAMICS_GLOBAL_ACCOUNT_NAME



_validateEnvironmentVars() {
  VAR_LIST=("$@") # rebuild using all args
  echo $VAR_LIST
  for i in "${VAR_LIST[@]}"; do
     [ -z ${!i} ] && { echo "Environment variable not set: $i"; ERROR="1"; }
  done
  [ "$ERROR" == "1" ] && { echo "Exiting"; exit 1; }
}


_read-controller-access-info() {
  _validateEnvironmentVars APPD_CONTROLLER_INSTALL_DIR APPD_DB_PWD
  $APPD_CONTROLLER_INSTALL_DIR/controller/db/bin/mysql -A -u root \
        -p${APPD_DB_PWD} --port=3388 \
        --protocol=TCP controller \
        -e "source controller-access-read.sql;"


}

_write-controller-access-info() {
  _validateEnvironmentVars APPD_CONTROLLER_INSTALL_DIR APPD_DB_PWD APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY APPDYNAMICS_GLOBAL_ACCOUNT_NAME
  $APPD_CONTROLLER_INSTALL_DIR/controller/db/bin/mysql -A -u root \
        -p${APPD_DB_PWD} --port=3388 \
        --protocol=TCP controller \
        -e "set @ACCESS_KEY='${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}'; \
            set @GLOBAL_ACCOUNT_NAME='${APPDYNAMICS_GLOBAL_ACCOUNT_NAME}'; \
            source controller-access-write.sql;"
}

_test-show-envvars() {
  _validateEnvironmentVars APPD_CONTROLLER_INSTALL_DIR APPD_DB_PWD APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY APPDYNAMICS_GLOBAL_ACCOUNT_NAME
  $APPD_CONTROLLER_INSTALL_DIR/controller/db/bin/mysql -A -u root \
        -p${APPD_DB_PWD} --port=3388 \
        --protocol=TCP controller \
        -e "set @ACCESS_KEY='${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}'; \
            set @GLOBAL_ACCOUNT_NAME='${APPDYNAMICS_GLOBAL_ACCOUNT_NAME}'; \
            source show-envvars.sql;"
}

CMD=$1; shift
case $CMD in
  test)        _test-show-envvars               $@ ;;
  read)        _read-controller-access-info     $@ ;;
  update)      _write-controller-access-info    $@ ;;
  *)           echo "Command unknown: [$CMD]"
esac
