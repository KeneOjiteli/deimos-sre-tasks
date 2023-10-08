#!/bin/sh

# kubectl port-forward service/podtatohead-podtatoserver -n podtatoargocd 9090:9000

kubectl port-forward service/podtatohead-podtato-head-entry  -n myapp 9090:9000

# kubectl port-forward service/podtato-head-test-entry  -n podtatoargocd 9091:9000