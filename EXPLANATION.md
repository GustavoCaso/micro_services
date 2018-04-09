### Heetch Challenge

Exercise proposed to build an HTTP gateway and two microservices. This approach allows users only to use one API which will work as a _public facing service_

The endpoints for the Gateway API are:

- GET `/driver/:id` returns the driver `zombie state`
- PATCH `/drivers/:id/locations` that would get coordinates in the payload and produce an *NSQ* message.

The other microservices `driver-location` listen for *NSQ* messages produced by the Gateway and store in *Redis* also provide a public endpoint that allows querying the coordinates information for a driver.

The `zombie-driver` will fetch the information provided by `driver-location` public endpoint and calculate if the driver is in `zombie` state.

## How to start the project

1. From the root of the project execute `docker-compose up` to have *Redis* and *NSQ* up and running
2. To start all microservices, please install `foreman` with `gem install foreman.`
  - I wasn't able to make it work with `Makefile` (sorry for that)
3. From the root of the project execute `foreman start`, this will install dependencies and start the process that is needed.

By default the ports for the different microservices are:

- _gateway_ localhost:4000
- _zombie-driver_ localhost:4001
- _driver-location_ localhost:4002

## Automated test provided

1. From the root of the project execute `make test` and should install all dependencies and execute specs

## Architecture of microservices

I decided to follow a simple design by using a lite way Ruby framework *Sinatra*, each has a small configuration `.env.` file that allows controlling some configuration parts of the microservices mostly related with `DOMAIN` and `HOST` of the microservices it communicates with.

## Overall

I did follow a profoundly influence dependency injection approach that would allow me to test much better in isolation each component. Also, I created some useful services that I placed in most of the microservices like `Result` object and `HttpRequest`. I like the `Result` object because allow me to use a simple interface for dealing with success or failure result from services.

### Gateway

When starting the application, it will read `config.yml.` and dynamically build the routes and use the information from the config file to route the request to the correct transportation layer, if for whatever reason any of the configuration it will not create any endpoint to avoid creating an endpoint without a complete spec.

Adding a new endpoint will merely need to add an entry in the config file.
If new transportation layer added, it would need to be added to the list in the `extract_protocol_builder` method. This method will probably need to be extracted in the future if many transportation layers are added.

Then each transportation layer will redirect base on the custom attributes from the config file to a specific class that will create the body of the endpoint.

### Driver Location

You can configure how many *NSQ* listeners are created modifying the `.env` file. This listener will keep in an endless loop listening for messages generated in the *Gateway*.
There it will store in *Redis* I decided to completely separate when writing and querying in their separate service allowing me testing in isolation.
I like to keep the `keys` in their file to have easy access.
Strategy for storing the `coordinates` in *Redis*
Since we are going to need to fetch them later based in a range of time, I decided to use a `SortedSet` having the key the `id` of the driver the score been the time the message has been created. That way when querying is easy to grab the range containing by levering the existing interface that *Redis* provide `zrangebyscore`.

## Zombie Driver

Query the driver location endpoint and based on the coordinates it will return if the driver is a `zombie`.
The majority of the logic is around calculating the distance between the two coordinates.

## Missing Things

I would love to have more time to implement

- Monitoring, Metrics, Tracking (Probably using `dry-monitor`)
- Logging
- Better Error Handling (circuit breaking)
- Introduce `dry-container` and `dry-auto_inject` to reduce the amount of code duplication for using dependency injection

## Side Notes

- First time work with microservices architecture
- Probably best challenge I have to do so far, really complete, I had to use new technology :) and I have the feeling is not even close to complete.






