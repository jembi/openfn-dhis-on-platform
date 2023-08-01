local cwd=$(dirname ${BASH_SOURCE[0]})
source "$cwd/../importer.sh"

local stack="${DHIS2_STACKNAME:-dhis2}"
local target=$(basename "$cwd")
importer::deploy_importer $stack $target "docker-compose.config.yml"
