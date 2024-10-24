#!/bin/bash

./build.sh && git add . && git commit -m "prod_deploy" && git push origin main
