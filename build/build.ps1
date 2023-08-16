# Description: Build the Jekyll site using Docker

# get the first argument passed to the script as workspaceFolder folder
$workspaceFolder = $args[0]
$port = 55580
# warn if the workspaceFolder is not set
if ($null -eq $workspaceFolder) {
    Write-Host "The workspaceFolder variable is not set. Please set it in the launch.json file."
    exit 1
}

# check if docker container with name "jekyll_build" exists
$container_name = "jekyll_build"
$jekyll_build_exists = docker ps -a | Select-String $container_name
# create it if it doesn't, and start it
if ($null -eq $jekyll_build_exists) {
    docker run --name $container_name -v ${workspaceFolder}:/srv/jekyll:Z -it jekyll/builder:stable jekyll build --trace
} else {
    docker start $container_name
    docker exec -it $container_name jekyll build --trace
}

$nginx_container_name = "nginx_serve_jekyll"
$nginx_container_exists = docker ps -a | Select-String $nginx_container_name
# create it if it doesn't, and start it
if ($null -eq $nginx_container_exists) {
    docker run --name $nginx_container_name -d `
    -p ${port}:80 `
    -v ${workspaceFolder}/_site:/usr/share/nginx/html:rw `
    -v ${workspaceFolder}/serve_with_nginx.conf:/etc/nginx/nginx.conf:ro `
    nginx:stable
} else {
    # start if not running
    docker start $nginx_container_name
}

Write-Host "Access the site at http://localhost:${port}"