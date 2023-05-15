https://sleeplessbeastie.eu/2022/08/31/how-to-use-go-sockaddr-template-to-define-ip-address/
https://pkg.go.dev/github.com/hashicorp/go-sockaddr/template
docker network list
docker network inspect hashistack_management | jq -r ".[0].IPAM.Config.Subnet"
docker ps
docker exec -it consul-server-0 /bin/ash
apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go
go install github.com/hashicorp/go-sockaddr/cmd/sockaddr@latest
export PATH="${PATH}:~/go/bin"
sockaddr eval -r '{{ GetAllInterfaces | include "network" "172.31.0.0/16" }}'