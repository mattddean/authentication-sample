import { Router } from "express";
import { logIn, logOut } from "../auth";
import { Unauthorized } from "../errors";
import { catchAsync, guest, auth } from "../middleware";
import { User } from "../models";
import { validate, loginSchema } from "../validation";

const INCORRECT_EMAIL_OR_PASSWORD_STRING = "Incorrect email or password";

const router = Router();

router.post(
  "/login",
  guest,
  catchAsync(async (req, res) => {
    await validate(loginSchema, req.body);

    const { email, password } = req.body;

    const user = await User.findOne({ email });

    // thwart timing attack
    if (!user) {
      await User.compare(
        "dummy string to hash",
        "$2a$14$0vPB6rpRlSEoc94.wG7mz.5laGZdfixl3KRzX3/p7ZYDrywQr3VBq"
      ); // simply discard result
      throw new Unauthorized(INCORRECT_EMAIL_OR_PASSWORD_STRING);
    }

    if (!(await user.passwordMatches(password))) {
      throw new Unauthorized(INCORRECT_EMAIL_OR_PASSWORD_STRING);
    }

    logIn(req, user.id);

    res.json({ message: "Login successful" });
  })
);

router.post(
  "/logout",
  auth,
  catchAsync(async (req, res) => {
    await logOut(req, res);

    res.json({ message: "Logout successful" });
  })
);

export default router;
