import { NextFunction, Request, Response } from "express";
import { isLoggedIn, logOut } from "../auth";
import { SESSION_ABSOLUTE_TIMEOUT } from "../config";
import { BadRequest, Unauthorized } from "../errors";

export const guest = (req: Request, res: Response, next: NextFunction) => {
  if (isLoggedIn(req)) {
    return next(new BadRequest("You are already logged in"));
  }

  next();
};

export const auth = (req: Request, res: Response, next: NextFunction) => {
  if (!isLoggedIn(req)) {
    return next(new Unauthorized("You must be logged in"));
  }

  next();
};

export const active = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (isLoggedIn(req)) {
    const { createdAt } = req.session as Express.Session;

    if (Date.now() > createdAt + SESSION_ABSOLUTE_TIMEOUT) {
      await logOut(req, res);

      return next(new Unauthorized("Session expired"));
    }
  }

  next();
};
