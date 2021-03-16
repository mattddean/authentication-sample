Based on YouTube series https://www.youtube.com/playlist?list=PLcCp4mjO-z9_HmJ5rSonmiEGfP-kyRMlI

## MongoDB Shell
### Connect to MongoDB shell

```bash
docker-compose exec db mongo -u admin -p secret auth
```

```bash
docker-compose exec cache redis-cli -a secret
```

### Delete all users

From within MongoDB shell

```
db.users.deleteMany({})
```

## Password Authentication
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
  -d '{ "email": "someone@gmail.com", "name": "Someone", "password": "Ś(54343434", "passwordConfirmation": "Ś(54343434" }'
```

## Logging In

```bash
# without cookie (responds with message: "Login successful")
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password54" }'

# fail: with cookie (responds with message: "You are already logged in")
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password54" }' --cookie 'sid=s%3AyurLv-_0u9wCJZAkGyDc8cQ-OPNPSAXa.Qe11bpohgT2XoHNMgOY7Yh1NNKgTyItiYGUb0d80jKY'

# fail: user doesn't exist (responds with message: "Invalid email or password")
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "another@gmail.com", "password": "a(password54" }'

# fail: incorrect password (responds with message: "Invalid email or password")
curl -v -X POST localhost:8080/login -H 'Content-Type: application/json' \
  -d '{ "email": "someone@gmail.com", "password": "a(password23" }'
```

## Logging Out

```bash
# with cookie (responds with message: "Logout successful")
curl -v -X POST localhost:8080/logout \
  --cookie sid=s%3AbD9a-v0qQ9shJaFT5shR565ZtoIfdvCT.gRf2cDpAE6rh6tW6tlnXnpFWBbQ0OTHt09RKl6GCNoc

# fail: without cookie (responds with message: "Logout successful")
curl -v -X POST localhost:8080/logout
```