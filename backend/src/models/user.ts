import { Schema, Model, Document, model } from "mongoose";
import { hash, compare } from "bcryptjs";
import { HASH_WORK_FACTOR } from "../config";

// instance properties and methods
export interface UserDocument extends Document {
  email: string;
  name: string;
  password: string;
  passwordMatches: (password: string) => Promise<boolean>;
}

// static properties and methods
export interface UserModel extends Model<UserDocument> {
  compare: (
    plaintextPassword: string,
    hashedPassword: string
  ) => Promise<boolean>;
}

export const userSchema = new Schema<UserDocument>(
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
  transform: (
    doc: Document,
    { email, name }: { email: string; name: string },
    options: any // eslint-disable-line @typescript-eslint/no-unused-vars
  ) => ({
    email,
    name,
  }),
});

export const User: UserModel = model<UserDocument, UserModel>(
  "User",
  userSchema
);
