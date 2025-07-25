nix build .#app
docker context use hostinger
docker load -i result
docker stack down helix-plugins
docker stack deploy --with-registry-auth -c compose.yml helix-plugins
