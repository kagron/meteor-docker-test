#!/usr/bin/bash

echo "[METEOR] Installing $NODE_ENV dependencies."

npm install

if [ $NODE_ENV = 'production' ]; then
    echo "[METEOR] Running Meteor Build."
    meteor build ../ --directory --server-only
    echo "[METEOR] Running npm install in built project"
    cd /bundle/programs/server && npm install
fi