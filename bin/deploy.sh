rsync -rva dist/server aztec:.
rsync -rva bin/* aztec:server
rsync -rva out/production/aztec/ aztec:/web
