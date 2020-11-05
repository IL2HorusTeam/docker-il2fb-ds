#!/usr/bin/env bash

set -e

JAVA_HEAP_MB_DEFAULT=256
JAVA_HEAP_MB=${IL2DS_JAVA_HEAP_MB:-$JAVA_HEAP_MB_DEFAULT}

if [[ -z "$JAVA_HEAP_MB" ]]; then
  echo "ERROR: env var 'IL2DS_JAVA_HEAP_MB': empty value" 1>&2
  exit 1
fi

declare -A JAVA_HEAP_MB_TO_DIR_NAME=( \
  ["256"]="256M_DS_(Default)" \
  ["384"]="384M_DS" \
  ["512"]="512M_DS" \
  ["768"]="768M_DS" \
  ["1024"]="1024M_DS" \
)

if [[ "$JAVA_HEAP_MB" -ne "$JAVA_HEAP_MB_DEFAULT" ]]; then
  if [[ -v "JAVA_HEAP_MB_TO_DIR_NAME[$JAVA_HEAP_MB]" ]] ; then
    DIR_NAME="${JAVA_HEAP_MB_TO_DIR_NAME[$JAVA_HEAP_MB]}"
    cp -f --preserve=all "/il2ds/EXE/DS_Server/$DIR_NAME/il2server.exe" "/il2ds/il2server.exe"
  else
    POSSIBLE_VALUES=$(printf %s\\n "${!JAVA_HEAP_MB_TO_DIR_NAME[@]}" | cut -d, -f1 | sort -nu | tr '\n' ' ' | sed 's/\s$//')
    echo -e "ERROR: env var 'IL2DS_JAVA_HEAP_MB': invalid value: $JAVA_HEAP_MB; possible values: $POSSIBLE_VALUES" 1>&2
    exit 1
  fi
fi

/usr/bin/wine /il2ds/il2server.exe -conf "$IL2DS_CONF" -cmd "$IL2DS_INIT"
