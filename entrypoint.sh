#!/bin/bash

#エラーが発生した段階で即座に終了する。
set -e

# -fオプションによって、対象ファイルが存在しなかった場合もエラーは返さない。
rm -f /pt_jump/tmp/pids/server.pid

exec "$@"