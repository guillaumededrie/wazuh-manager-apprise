base_image_name := `awk 'toupper($1) == "FROM" {print $2; exit}' Dockerfile`
local_image_name := "wazuh-apprise:local"

print-base-image-name:
    @echo "The Base image is: {{base_image_name}}"

enter-image name:
    @sudo docker run --rm --interactive --tty --entrypoint "/bin/bash" {{name}}

enter-base-image:
    just enter-image {{base_image_name}}

build target="production":
    @sudo docker build --target {{target}} --tag {{local_image_name}}-{{target}} .

enter-local-image target="production":
    just build {{target}}
    just enter-image {{local_image_name}}-{{target}}
