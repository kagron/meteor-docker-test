#!/usr/bin/bash

echo "[METEOR] Starting $NODE_ENV server."

if [ $NODE_ENV = 'production' ]; then
    node /bundle/main.js
else
    npm start
fi