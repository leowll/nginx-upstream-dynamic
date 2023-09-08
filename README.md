# Custom NGINX Docker Image

This Dockerfile is used to create a custom NGINX Docker image with a specific configuration and an added module called `nginx-upstream-dynamic-resolve-servers`. The image is based on the official NGINX Alpine image (version 1.25.2).

Without this image, you will not be able to resolve the upstream servers dynamically from DNS since this feature is only available in NGINX Plus.

With this image, you can run NGINX containers with the custom module and your custom configuration like below.

It will resolve the upstream servers dynamically from DNS.
```nginx
    upstream backend-service1 {
        server www.google.com resolve;
    }
    
    upstream backend-service2 {
        server www.yahoo.com resolve;
    }
```


## Usage

### 1. Building the Custom Image

To build the custom NGINX image, make sure you have Docker installed on your system and follow these steps:

- Place this Dockerfile in a directory along with your custom `ngx_http_upstream.c` file and any custom NGINX configuration files you may have, such as `nginx.conf`.

- Open a terminal and navigate to the directory containing the Dockerfile.

- Build the Docker image using the following command, replacing `your-image-name:tag` with the desired name and tag for your image:

  ```bash
  docker build -t your-image-name:tag .
  ```

### 2. Running a Container

After building the custom image, you can run NGINX containers based on this image with your custom configuration.

Example:

```bash
docker run -d -p 80:80 --name my-custom-nginx-container your-image-name:tag
```

- `-d`: Runs the container in detached mode (in the background).
- `-p 80:80`: Maps port 80 from the container to port 80 on your host machine.
- `--name my-custom-nginx-container`: Assigns a name to the running container.

### 3. Accessing NGINX

Once the container is running, you can access NGINX by opening a web browser and navigating to `http://localhost` (assuming you mapped port 80 to the host).

## Important Notes

- This Dockerfile fetches the NGINX source code, builds it with the custom module, and installs the NGINX binary. It also copies your custom `ngx_http_upstream.c` into the NGINX source code before building.

- You can customize the NGINX configuration by modifying `nginx.conf` and any other configuration files as needed.

- Make sure to replace `your-image-name:tag` with your desired image name and tag when building and running the container.

- The exposed port is 80, which is the default HTTP port. You can adjust the port mapping in the `docker run` command to fit your requirements.

- The `nginx-upstream-dynamic-resolve-servers` module should be available in the GitHub repository specified in the Dockerfile. Ensure that the repository is accessible and contains the necessary module files.

- Be cautious when deploying custom NGINX configurations in production environments, and thoroughly test your configuration before deployment.

Feel free to adapt this README.md to include any specific details or usage instructions that are relevant to your use case.