#!/bin/sh

set -eu

config=${1:-lua-project.json}
action=${2:-all}

filter_args='to_entries[] | select(.key != "folders")'

get_args() {
  target=".$1"
  result='"--\(.key)"'
  filter="$target | $filter_args | select(.value == true) | $result"
  
  jq -r "$filter" "$config" | tr '\n' ' ' | xargs echo
}

get_vargs() {
  target=".$1"
  result="\"--\(.key)='\(.value)'\""
  filter="$target | $filter_args | select(.value != true) | $result"
  
  jq -r "$filter" "$config" | tr '\n' ' ' | xargs echo
}

LUA_PATH=$(jq -r '.files[]' "$config" | awk '{print "/data/" $1 "/?.lua"}' | tr '\n' ';')
export LUA_PATH

custom=$(echo "$*" | awk '{ $1 = ""; $2 = ""; print $0 }')

if [ ! "$action" = 'test' ]; then
  args=$(get_args format)
  vargs=$(get_vargs format)
  
  format_custom=$(echo "$custom" | xargs echo | tr ' ' '\n' | grep '^--f_' | cut -c 1-2,5- | sed 's/--check//g')
  if ! echo "$format_custom" | grep -q '^--in-place$'; then
    format_custom="$format_custom --check"
  fi
  format_custom=$(echo "$format_custom" | xargs echo)

  echo '===== Formatting ====='
  sh -c "lua-format --dump-config $args $vargs $format_custom"

  jq -r '.files[]' "$config" | \
    awk '{print "/data/" $1 "/"}' | \
    xargs -n 1 -I{} find {} -name '*.lua' | \
    tr '\n' ' ' | \
    xargs -I{} sh -c "lua-format {} -v $args $vargs $format_custom" | tee -a /tmp/result.txt

  if [ -s /tmp/result.txt ]; then
    echo '    === Failed, uncorrect files: ==='
    cat /tmp/result.txt
    echo '    === Try format it by passing arg --f_in-place ==='
    exit 1
  else
    echo '    === Success ==='
  fi
fi

if [ ! "$action" = 'format' ]; then
  args=$(get_args test)
  vargs=$(get_vargs test)

  test_custom=$(echo "$custom" | tr ' ' '\n' | xargs echo | grep '^--t_' | cut -c 1-2,5- | tr '\n' ' ')

  folders=$(jq -r '.test.folders | join(" ")' "$config" | xargs echo)

  sh -c "busted $args $vargs $test_custom -- $folders"
fi
