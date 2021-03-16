Based on YouTube series https://www.youtube.com/playlist?list=PLcCp4mjO-z9_HmJ5rSonmiEGfP-kyRMlI


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