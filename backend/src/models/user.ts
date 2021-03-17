import { Schema, model, Document } from "mongoose";
import { hash, compare } from "bcryptjs";
import { HASH_WORK_FACTOR } from "../config";

interface UserDocument extends Document {
  email: string;
  name: string;
  password: string;
  passwordMatches: (password: string) => Promise<boolean>;
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

userSchema.statics.compare = function (
  plaintextPassword: string,
  hashedPassword: string
) {
  return compare(plaintextPassword, hashedPassword);
};

userSchema.methods.passwordMatches = function (password: string) {
  return User.compare(password, this.password);
};

userSchema.set("toJSON", {
  transform: (doc, { email, name }, options) => ({ email, name }),
});

export const User = model("User", userSchema);
