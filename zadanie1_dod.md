Budowanie 

`docker buildx build --platform linux/amd64,linux/arm64 --cache-to type=inline --cache-from type=registry,ref=d4sk/labtest:zadanie1 --sbom=true --provenance=true --tag d4sk/labtest:zadanie1 --push .`