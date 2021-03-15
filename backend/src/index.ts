import mongoose from "mongoose";
import Redis from "ioredis";
import session from "express-session";
import connectRedis from "connect-redis";
import { MONGO_URI, MONGO_OPTIONS, REDIS_OPTIONS, APP_PORT } from "./config";
import { createApp } from "./app";

(async () => {
  mongoose.connect(MONGO_URI, MONGO_OPTIONS);

  const RedisStore = connectRedis(session);

  const client = new Redis(REDIS_OPTIONS);

  const store = new RedisStore({ client });

  const app = createApp(store);

  app.listen(3000, () => console.log(`http://localhost:${APP_PORT}`));
})();
