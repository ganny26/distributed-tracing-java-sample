### Java example with Spring for distributed tracing

This project demonstrates how to implement distributed tracing in java spring boot application with the help for below microservices

- [order-service](order-service)
- [payment-service](payment-service)
- [user-service](user-service)

### Running the code

This application require Eureka service registry

```
cd discovery-server
gradle bootJar
docker build -t discovery-service:1.0.1 .
docker run -d --name discovery-service -p 8761:8761 discovery-service:1.0.1
```

Run `http://localhost:8761`

Start individual microservice using below commands

1. UserService

```
cd user-service || exit
sudo docker stop user-service || true
sudo docker rm user-service || true
gradle bootJar
sudo docker build -t user-service .
sudo docker run -d --network host --name user-service user-service
cd -
```

2. OrderService

```
cd order-service || exit
sudo docker stop order-service || true
sudo docker rm order-service || true
gradle bootJar
sudo docker build -t order-service .
sudo docker run -d --network host --name order-service order-service
cd -

```

3. PaymentService

```
cd payment-service || exit
sudo docker stop payment-service || true
sudo docker rm payment-service || true
gradle bootJar
sudo docker build -t order-service .
sudo docker run -d --network host --name payment-service order-service
cd -

```

5. Jaeger

TODO-> Make sure jaeger is available at `localhost:14250`.

6. Call the order command which will call both the `user-service` and `payment-service`:
```shell
curl --location --request POST 'localhost:8083/orders/create/id/9' \
--header 'X-API-Key: AQEmhmfuXNWTK0Qc+iSEl3cshOuWWIpDFNWZ7BldpzFgqjaFCkrORCwQwV1bDb7kfNy1WIxIIkxgBw==-AOBzxgPlXqtBf91jbKBJPbbLuET0Ou3aYjGklucQmGY=-Px5Jgb5:B6;[^Dsvallow' \
--header 'Content-Type: application/json' \
--data-raw '{
    "productName": "MacBook Pro",
    "price": "1100"
}'
```

---
## Virtual machine with vagrant and Parallels
One can also use a VM (like I do). There's a `Vagrantfile` in the root directory, so simply run `vagrant up --provision` in this directroy.
The above mentioned start commands are also in `./scripts/rebuild.sh` deploying all 4 apps right away. Note that this vagrant box is specifically for aarch64 (Macbook M1).
