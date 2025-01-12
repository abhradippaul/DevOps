docker build -t developing_backend --build-arg PORT=5000 -f .\Dockerfile .

docker run -d --name backend_container -p 5000:5000 developing_backend

docker rm backend_container --force

docker run -d --name backend_container -p 5000:5000 -v "C:\Users\abhra\Desktop\DevOps\Docker\Developing backend with container\src:/apps/src" developing_backend

docker restart backend_container

