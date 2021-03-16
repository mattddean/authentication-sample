import { Schema, model, Document } from "mongoose";
import { hash } from "bcryptjs";
import { HASH_WORK_FACTOR } from "../config";

interface UserDocument extends Document {
  email: string;
  name: string;
  password: string;
}

const userSchema = new Schema(
  {
    email: String,
    name: String,
    password: String,
  },
  {
    timestamps: true,
  }
);

userSchema.pre<UserDocument>("save", async function () {
  if (this.isModified("password")) {
    this.password = await hash(this.password, HASH_WORK_FACTOR);
  }
});

export const User = model("User", userSchema);
