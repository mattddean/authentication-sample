import express from "express";
import session, { Store } from "express-session";
import { SESSION_OPTIONS } from "./config";
import {
  catchAsyncRequest,
  active,
  InternalServerError,
  NotFoundError,
} from "./middleware";
import { login, register, me } from "./routes";

export const createApp = (store: Store) => {
  const app = express();

  app.use(express.json());

  app.use(
    session({
      ...SESSION_OPTIONS,
      store,
    })
  );

  app.use(catchAsyncRequest(active));

  app.use(me);

  app.use(login);

  app.use(register);

  app.use(NotFoundError);

  app.use(InternalServerError);

  return app;
};
