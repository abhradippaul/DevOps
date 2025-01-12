# 🐳 Express Backend Project (Dockerized for Development)

Welcome to the **Express Backend Project**, designed to streamline development with Docker! Develop your fast and lightweight backend using express in a fully containerized environment.

---

## 🚀 Getting Started with Docker for Development

docker build -t developing_backend --build-arg PORT=5000 -f .\Dockerfile . -> To Build the custom image from yaml file

- -t -> For tagging the image
- --build-arg -> For passing the arg to the image
-  -f -> For the docker file

![Screenshot 2025-01-11 200958](https://github.com/user-attachments/assets/3ec9a23e-1325-4a32-a729-ac0ac34bf1aa)

The image is ready.

docker run -d --name backend_container -p 5000:5000 developing_backend -> Create the container from the image

- -d -> Running the container with detach mode
- --name -> Providing a name for the container
- -p -> For port mapping (Exposing port -> 5000:5000 -> The left side port is for the host machine and the right side port is for the container's internal port)

![Screenshot 2025-01-11 201056](https://github.com/user-attachments/assets/e27730cc-a06a-48a4-bb09-ca001b57e9e3)

The container is ready.

![Screenshot 2025-01-11 201115](https://github.com/user-attachments/assets/ca588d28-00cc-4c0d-a6ee-04c36d2a9fd8)

And working on the 5000 port. But the problem is if the code is changed for the image we have to build the image repeatedly. This is not the right path to developing code in a docker container.

docker rm backend_container --force -> Deleting the container

- --force -> To delete the container without stopping the container.

docker run -d --name backend_container -p 5000:5000 -v "C:\Users\abhra\Desktop\DevOps\Docker\Developing backend with container\src:/apps/src" developing_backend -> Creating the container again

- -v -> It is used for volume binding. This means that if the host URL code changes, it will be reflected in the right-side container path.

![Screenshot 2025-01-11 202420](https://github.com/user-attachments/assets/69081031-b9b6-4bf3-adba-8a2b7c22c5ee)

The container is created again with volume bind.

docker restart backend_container -> Restart the container (Needed in Windows)

![Screenshot 2025-01-11 202630](https://github.com/user-attachments/assets/b7d7968f-f15c-4450-9943-cfe49481cf1d)

And it updates without rebuilding the image.
