#!/bin/bash

rm -rf teleport
cp -r ~/go/bin/teleport teleport

docker build -t webbshi/teleport:v0.1.0-alpha2 .


docker push webbshi/teleport:v0.1.0-alpha2