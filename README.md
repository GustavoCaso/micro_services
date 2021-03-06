To support our growth, we have taken the microservice route. So let’s tackle the basics with a HTTP gateway that either forward requests or transforms them into [NSQ](https://github.com/nsqio/nsq) messages for asynchronous processing. Next we’ll add two services that perform most common tasks while transporting people from A to B.

Let’s get down to business.

All drivers are sending their current coordinates to the backend, every five seconds. Some drivers may be considered as zombies if they match a specific predicate. So we have an application that says if a driver is zombie or not.

Thus, you will implement three services as following:

- a `gateway` service, that either forward or transform requests to be processed synchronously or asynchronously
- a `driver location` service, that consumes location update events and store them
- a `zombie driver` service, that allows to check if a driver matches the zombie predicate or not

### 1. Gateway Service
The `Gateway` service is a _public facing service_.
HTTP requests hitting this service are transformed into [NSQ](https://github.com/nsqio/nsq) messages or forwarded in HTTP to specific services.
The gateway should use the provided `config.yaml` file to register endpoints.

#### Public Endpoints

`PATCH /drivers/:id/locations`

**Payload**

```
{
  "latitude": 48.8566,
  "longitude": 2.3522
}
```

**Role:**

In a typical evening thousands of drivers send their coordinates every 5 seconds to this endpoint.

**Behaviour**

Coordinates received on this endpoint are converted to [NSQ](https://github.com/nsqio/nsq) messages listened by the `Driver Location` service.

---

`GET /drivers/:id`

**Response**

```
{
  "id": 42,
  "zombie": true
}
```

**Role:**

The users request this endpoint to know if a driver is a zombie.
A zombie is a driver that has not moved more than 500 meters in the last 5 minutes.

**Behaviour**

This endpoint forward the HTTP request to the `Zombie Driver` service.

### 2. Driver Location Service
The `Driver Location` service is a microservice that consumes drivers location messages published by the `Gateway` service and stores them in a Redis database.
It also provides an internal endpoint that allow other services to retrieve the drivers data.

#### Internal Endpoint

`GET /drivers/:id/locations?minutes=5`

**Response**

```
[
  {
    "latitude": 42,
    "longitude": 2.3,
    "updated_at": "YYYY-MM-DDTHH:MM:SSZ"
  },
  {
    "latitude": 42.1,
    "longitude": 2.32,
    "updated_at": "YYYY-MM-DDTHH:MM:SSZ"
  }
]
```

**Role:**

This endpoint is called by the `Zombie Driver` service.

**Behaviour**

Returns for a given driver all his coordinates from the last 5 minutes (given `minutes=5`).


### 3. Zombie Driver Service
The `Zombie Driver` service is a microservice that determines if a driver is a zombie or not.

#### Internal Endpoint

`GET /drivers/:id`

**Response**

```
{
  "id": 42,
  "zombie": true
}
```

**Role:**

This endpoint is called by the `Gateway Service`.

**Predicate**

> driver has not moved from more than 500 meters in the last 5 minutes.

**Behaviour**

Returns for a given driver his zombie state.


### Prerequisites
- handle all failure cases
- the gateway should be configured using the `config.yaml` file
- provide a clear explanation of your approach and design choices (while submitting your Pull Request)
- provide a proper `README.md`:<br/>
- explaing how to setup and run your code<br/>
- including all informations you feel that may be useful for a seamless coworker on-boarding

### Workflow
- use the programming language of your choice either in Go, Elixir or Ruby
- you can use the provided `docker-compose` file to run NSQ and Redis
- create a new branch
- commit and push to this branch
- submit a pull request once you have finished

We will then write a review for your pull request!

### Bonus

- Add metrics / request tracing / circuit breaking 📈
- Add whatever you think is necessary to make the app awesome ✨
