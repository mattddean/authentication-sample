# Authentication Sample Backend

# Overview and Credit

From YouTube series https://www.youtube.com/playlist?list=PLcCp4mjO-z9_HmJ5rSonmiEGfP-kyRMlI, plus improvements such as:

- Thwart timing attacks
  - By hashing a dummy string
    - The problem and solution were identified in the video series, but not implemented
    <!-- - Send back user object during `/login` request rather than requiring a separate `/me` request -->
- Fix types such that TypeScript compiles correctly
- Build a production Docker image for cloud deployment

## Features

- Hashed passwords
- Simple document databae (MongoDB) that would enable easy improvement and expansion of the project
<!-- - Fully realized Terraform IoC with zero manual AWS configuration -->

## Start development environment

```bash
CURRENT_USER_ID=$(id -u) CURRENT_GROUP_ID=$(id -g) docker-compose up backend
```

> The `backend` service depends on `db` and `cache`, so these will be brought up automatically.

## MongoDB Shell

### Connect to MongoDB shell

```bash
docker-compose exec db mongo -u admin -p secret auth
```

```bash
docker-compose exec cache redis-cli -a secret
```

### Delete all users

From within MongoDB shell:

```
db.users.deleteMany({})
```

## Redis Shell

### Connect to Redis shell

With the `cache` service running:

```bash
docker-compose exec cache redis-cli -a secret
```

### View active sessions

From within Redis shell:

```bash
scan 0
```

### Get cookie information for a session

From within Redis shell:

```bash
get "<session>"
```

### Flush all sessions

From within Redis shell:

```bash
flushall
```

## Routes

### Password Authentication

```bash
# invalid passwords
curl -v -X POST localhost:8080/register -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "aPassword54", "passwordConfirmation": "aPassword54" }'
curl -v -X POST localhost:8080/register -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "apassword54", "passwordConfirmation": "apassword54" }'

# valid passwords
curl -v -X POST localhost:8080/register -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "apassword54!", "passwordConfirmation": "apassword54!" }'
curl -v -X POST localhost:8080/register -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "a(password54", "passwordConfirmation": "a(password54" }'
# demonstrating a unicode character
curl -v -X POST localhost:8080/register -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "??(54343434", "passwordConfirmation": "??(54343434" }'
```

### Logging In

```bash
# without cookie (responds with message: {"Login successful"})
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password54" }'

# fail: with cookie (responds with message: {"You are already logged in"})
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password54" }' --cookie 'sid=s%3AyurLv-_0u9wCJZAkGyDc8cQ-OPNPSAXa.Qe11bpohgT2XoHNMgOY7Yh1NNKgTyItiYGUb0d80jKY'

# fail: user doesn't exist (responds with {message: "Invalid email or password"})
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "another@gmail.com", "password": "a(password54" }'

# fail: incorrect password (responds with {message: "Invalid email or password"})
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password23" }'
```

### Logging Out

```bash
# with cookie (responds with message: "Logout successful")
curl -v -X POST localhost:8080/logout \
  --cookie sid=s%3AbD9a-v0qQ9shJaFT5shR565ZtoIfdvCT.gRf2cDpAE6rh6tW6tlnXnpFWBbQ0OTHt09RKl6GCNoc

# fail: without cookie (responds with {message: "You must be logged in"})
curl -v -X POST localhost:8080/logout
```

### Getting authenticated user

```bash
# with cookie (responds with message {email: <email>, password: <password>})
curl -v localhost:8080/me --cookie sid=s%3ATd2hIdcEKi5NjNcq5nKO_QDDBCSEg--f.aIJLZOkYkdxNs4kVcDFJoUAGASJ62myswncrV3w7M%2FI

# fail: without cookie (responds with {message: "You must be logged in"})
curl -v localhost:8080/me
```
