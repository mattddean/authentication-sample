import mongoose from "mongoose";
import Redis from "ioredis";
import session from "express-session";
import connectRedis from "connect-redis";
import {
  MONGO_URI,
  MONGO_OPTIONS,
  REDIS_OPTIONS,
  APP_PORT,
  REDIS_HOST,
} from "./config";
import { createApp } from "./app";

(async () => {
  console.log(`Will attempt to connect to Redis at endpoint ${REDIS_HOST}`);
  console.log(`Will attempt to connect to Mongo at endpoint ${MONGO_URI}`);

  mongoose.connect(MONGO_URI, MONGO_OPTIONS);

  const RedisStore = connectRedis(session);

  const client = new Redis(REDIS_OPTIONS);

  const store = new RedisStore({ client });

  const app = createApp(store);

  app.listen(APP_PORT, () => console.log(`http://localhost:${APP_PORT}`));
})();
