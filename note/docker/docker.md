# Docker
The first question in my mind, why Docker?
1. "It works on my machine" problem
2. Isolation
3. Lightweight 
4. Portability
5. Scalability 
and so many feature.
## Main Concept in Docker
There is three main concept in Docker you should know:
1. Container: 
	- a lightweight, portable box that holds everything that your application needs. 
	- It is running and isolated (some kind of **process sandbox**).
2. Image:
	- It is like a blueprint.
	- It is **read-only**, and define what must be in a container like OS, dependencies, software and configuration.
	- You do not run an image directly, you run an container from an image.
	- Images are build from different layers (each command on Dockerfile add new layer).
3. Registry:  
	- It is like a **storage/repository** (like Github, but for images).
	- There are public and private registry.

## Container Life Cycle
### Run/Pull
Instead of pulling an image and then run it, you can directly use `run` command:
```bash
docker run --name <your_desired_name> -d -p 8080:80 nginx
```
- `--name`: set your desired name, better for management.
- `-d`: detached, run the container in background.
- `-p`: port mapping.
- `nginx`: obviously the image name.
### Start/Stop
Simply: 
```bash
docker stop <container_name>
docker start <container_name>
```
Note that the written layer dose not destroy.
### Exec
```bash
docker exec -i -t <container_name> sh
```
- `-i`: interactive.
- `-t`: terminal interface for interacting.
- `sh`: shell for interaction.
### Logs
```bash
docker logs <container_name>
```
Show STDOUT/STDERROR without getting into the container.

## Key Notes
1. Container are temporary: the content which your container made (when was running) will get deleted after removing the container.
2. Multi container can made from one image: and there is no conflict between them of course.
3. A container = process PID + writable layer + network + limited source
	- When a container get removed the writable layer still remain till you restart or delete it.
4. Real debug tool, `logs` & `exec`:
	- `logs`: output of the main app.
	- `exec`: inter to the real environment, change/experiment.

## Deletion and Space Managing
- Remove stopped container:
```bash
docker rm <container>
docker rm $(docker ps -a -q)
```
- Delete images:
```bash
docker rmi <image>
```

## Data & Networs in Docker
There is a problem:
1. Anything you created in a container will destroy after deleting the container.
2. Container is isolated from each other, so they can not talk.

Docker gives you two big option:
1. Volume (data)
2. Networks (communication)

### Volume - Saving Data
Volumes are just folders that managed by Docker outside the container's writable layer. Type of storage:
1. Anonymous volume:
	- Create anonymously but you do not have control where is it.
	- Example (`/data` the folder inside the container to the random place outside the container):
	```bash
		docker run -v /data busybox
	```
2. Named volume:
	- You gave a name to a volume and you can reuse it later.
		- Example (`/data` is save to a volume called `mydata):
		```
		docker run -v mydata:/data busybox
		```
3. Bind mount:
	- You connect a folder from your host machine directly into the container
	- Example:
		```bash
		docker run -v $(pwd):/app busybox
		```

**Note**: the volume which you created for you container located on:
```bash
/var/lib/docker/volumes/<volume_name>/_data
```
And you can see all the volume created by:
```bash
docker volume ls
```
Inspecting them:
```bash
docker volumes inspect <volume_name>
```

Note that editing the data in the `/var/lib/docker/...` can break thing. The write way is to use `docker cp` or mounting them in another place.
### Networks - How Container Talk
Dockers network are like virtual-LANs. By default docker connect container by bridge network. Useful networks type:
1. Bridge network:
```bash
docker network create <network_name>
docker run -d --name mydb --network <network_name> postgres 
docker run -it --name app --network <network_name> busybox sh	
```
2. Host network: container share the host network (no isolation).
```bash
docker run --network host nginx
```
By this command Nginx is accessible through the host's ports.

### Ports
Container has there own network, But how they communicate to outside world (host)? By mapping **ports**.
```bash
docker run -d -p 8080:80 nginx
```
- `8080:80`:
	- `80`: inside container, Nginx default port.
	- `8080`: port on your host, forward container traffic on port 80 to this port.
Now if you open localhost:8080 on your computer/host you will see the default page of Nginx.

## Build My Own Image
### What's is Really an Image?
- Image is a snapshot of file systems and the instruction to run.
- It's read-only.
- Image has layers:
	- Each line in Dockerfiles add new layer.
	- Layers are cashed: make build faster.

### Dockerfile basics
It is just a text file with instruction to build an image. Example:
```dockerfile
# Step 1: Start from a base image
FROM python:3.10

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy files into the container
COPY requirements.txt .

# Step 4: Install dependencies
RUN pip install -r requirements.txt

# Step 5: Copy the rest of the code
COPY . .

# Step 6: Define the default command
CMD ["python", "app.py"]
```
Key words:
- `FROM`: base image.
- `WORKDIR`: work directory inside the image.
- `COPY`: copy file from host to the container.
- `RUN`: run command while building the image (install packages etc.).
- `CMD`: default command when container start.
- `EXPOSE`: document what port app runs on.

To build this image:
```bash
docker build -t myapp:1.0 .
```
- `-t myapp:1.0`: specify the name and the version.
- `.`: build context.
Now you can run:
```bash
docker run -p 5000:5000 myapp:1.0
```

## Docker Compose
When you need multiply container to work together (app + database + frontend ...). You can use `docker run`, but is't messy and hard when your application is huge.
So we use:
```bash
docker-compose up
```
In YAML file (`docker-compose.yml`) you will describe:
- Which image to use
- Ports to use
- Networks to use
- Volumes to use

Imagine this scenario: you have a Flask app with Postgres database.
Without Docker compose:
```bash
docker network create mynet
docker run -d --name db --network mynet -v pgdata:/var/lib/postgresql/data postgres
docker run -d --name app --network mynet -p 5000:5000 flaskapp
```
With compose:
```yml
version: "1.0"

services:
	db:
		images: postgres:1.5
		container_name: db
		environment:
			POSTGRES_USER: user
			POSTGRES_PASS: pass
			POSTGRES_DB: mydb
		volumes:
			- pgdata:/var/lib/postgresql/data
	
	app:
		build: .
		container_name: app
		ports:
			- "5000:5000"
		depends_on:
			- db

volumes:
	pgdata:
```
Now just run:
```bash
docker-compose up
```

### Key concept
- `services`: containers.
- `volumes`: persistent data storage.
- `networks`: container-to-container communication (create automatically by `docker-compose`)
- `depends_on`: order of startup (your `app` will wait for `db`)

### Useful commands
- `docker-compose up`: start everything
- `docker-compose up -d`: deattache (run in background)
- `docker-compose down`: remove everything (containers, networks, etc ... but keep the volumes) 
- `docker-compose down -v`: remove volumes to
- `docker-compose logs -f`: follow logs from every containers
- `docker-compose exec <container_name> bash`: open a shell inside `container`

## Environment Management & Config
Real apps are not just "app + db", they need configs:
- Environment variables
- Secrets
- Different setup for development & production

### Env Variable in Docker
Use `-e` for pass env variable:
```bash
docker run -e POSTGERS_USER=user -e POSTGRES_PASS=pass postgres
```
Inside the container they become available.

### Env Variable in Docker Compose
```yml
services:
	db:
		images: postgres:1.5
		environment:
			POSTGRES_USER: user
		    POSTGRES_PASSWORD: pass
		    POSTGRES_DB: mydb
```
Or the better way is to load it from a `.env` file (more secure):
```env
POSTGRES_USER=user
POSTGRES_PASSWORD=pass
```
And then:
```yml
environment:
	POSTGRES_USER: ${POSTGRES_USER}
	POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
```

### Configs for Different Environments
- Development mode: easy debugging, live reload, less security.
- Production mode: optimized, no debugging tool, stronger configs.
Different compose files:
-  `docker-compose.dev.yml`
- `docker-compose.prod.yml`
Run by:
```bash
docker-compose -f docker-compose.dev.yml up
```

### Secrets
For more important data like API key or database password Docker has secrets.
In compose:
```yml
services:
	app:
		image: myapp
		secrets:
			- db_password

secrets:
	db_password:
		file: ./db_password.txt
```
Inside the container secrets are in: `/run/secrets/db_password`

## Scaling and Replies
Instead of running one container per service, we can scale service horizontally (multiple container of a service), so:
- If one crash, there is other running.
- More user can connect.
- You are closer to real production setup.

### `--scale`
Example:
```bash
docker-compose up --scale app=3
```

### Docker Compose
Example:
```yml
version: "3.1"

services:
	app:
		build: .
		ports:
			- "5000:5000"
		deploy:
				replicas: 3
```
Note that `deploy` is only works for swarm mode.

### Port Binding Problem
You can not bind one port in your host to the different container, so:
```yml
ports:
	- "5000"
```
We remove host port and docker will automatically bind random ports, `13434`, `54213`, etc. Also you can use a load balancer (like Nginx, Traefik, ...)

### Networking & Load Balancing 
Basic Nginx load balancer:
```yml
version: "3.9"
services:
  app:
    build: .
    expose:
      - "5000"   # expose internally (not host binding)
    networks:
      - appnet
    deploy:
      replicas: 3

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    networks:
      - appnet

networks:
  appnet:
```
Nginx config:
```nginx
http {
  upstream app_cluster {
    server app:5000;
  }

  server {
    listen 80;
    location / {
      proxy_pass http://app_cluster;
    }
  }
}
```

## Registries & Publishing Images
- Share image with your team
- Deploy them on server/cloud
- Use CI/CD pipeline
That's where registries come in. A registries is like a Github repo but for Docker images:
- You `push` images to them
- Other `pull` them
- Default registry: Docker Hub
Other registry:
- Github Container Registry (GHCR)
- Gitlab
- AWS ECR, Google GCR, Azure ACR
- Or host your own
### Key Concept
- Every images has: `<name>:<tag>`
- Logging into a registry: `docker login`
- To push an image (app version 1.0):
	- Tag it: `docker tag myapp:1.0 <username>/myapp:1.0`
	- Push: `docker push <username>/myapp:1.0`
	- Now anyone can run: `docker run <username>/myapp:1.0`
- Pulling image: `docker pull postgres:15`, this will download the image and then you can `run` it.
