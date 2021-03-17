import { Router } from "express";
import { auth, catchAsyncRequest } from "../middleware";
import { User } from "../models";

const router = Router();

router.get(
  "/me",
  auth,
  catchAsyncRequest(async (req, res) => {
    const user = await User.findById(req.session.userId);

    res.json(user);
  })
);

export default router;
