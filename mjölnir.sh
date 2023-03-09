#!/bin/zsh

build() {
  eval $(ssh-agent) && \
  ssh-add ~/.ssh/GitHub && \
  export DOCKER_BUILDKIT=1 && docker build \
        --ssh default=$(echo $SSH_AUTH_SOCK) \
        -t mjolnir:latest \
        --build-arg CACHEBUST=$(date +%s) \
        /home/florian/syncthing/Development/reverse-engineering/Mjölnir/
}

run() {
# -v $HOME/.ssh:/root/.ssh \
 docker run --rm -d -i \
    -v $PWD:/pwd --cap-add=SYS_PTRACE \
    -v /home/florian/syncthing/Development/reverse-engineering/Mjölnir/home/.zsh_history:/root/.zsh_history \
    --security-opt \
    seccomp=unconfined \
    --network=host \
    --name=mjolnir \
    --hostname=mjolnir \
    mjolnir:latest
}

exec_into() {
  docker exec -it mjolnir /bin/zsh
}

stop() {
  docker stop mjolnir
}

reset() {
  stop
  run
  exec_into
}

if [ "$1" = "run" ]; then
  echo "RUN!"
  run
elif [ "$1" = "build" ]; then
  echo "BUILD!"
  stop
  build
elif [ "$1" = "exec" ]; then
  echo "EXEC!"
  exec_into
elif [ "$1" = "stop" ]; then
  stop
elif [ "$1" = "reset" ]; then
  reset
elif [ "$1" = "" ]; then
  if [ $( docker ps -f name=mjolnir | wc -l ) -lt 2 ]; then
    run
  fi
  exec_into
fi
