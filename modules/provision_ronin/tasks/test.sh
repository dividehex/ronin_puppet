#!/bin/sh

echo testing

nohup bash -c "sleep 15 </dev/null >/dev/null 2>&1" &

echo end test
exec
