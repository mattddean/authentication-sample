import { ConnectionOptions } from "mongoose";

const {
  MONGO_USERNAME = "admin",
  MONGO_PASSWORD = "secret",
  MONGO_HOST = "localhost",
  MONGO_PORT = "27017",
  MONGO_DATABASE = "auth",
  MONGO_CONN_STRING_ENDING = "/?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false",
} = process.env;

export const MONGO_URI = `mongodb://${MONGO_USERNAME}:${encodeURIComponent(
  MONGO_PASSWORD
)}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DATABASE}${MONGO_CONN_STRING_ENDING}`;

export const MONGO_OPTIONS: ConnectionOptions = {
  useNewUrlParser: true,
  useUnifiedTopology: true,
};
