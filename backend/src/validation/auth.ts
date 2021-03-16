import Joi from "@hapi/joi";
import { HASH_MAX_BYTES } from "../config";

const email = Joi.string()
  .email()
  .min(8)
  .max(254)
  .lowercase()
  .trim()
  .required();
const name = Joi.string().min(3).max(128).trim().required();
const password = Joi.string()
  .min(8)
  .max(HASH_MAX_BYTES, "utf8")
  .regex(
    // uppercase     lowercase
    /^(?=.*?[\p{Lu}\p{Ll}])(?=.*?\d)(?=.*?[#?!@$%^&*-+_[\]()=`~\\|]).*$/u
  )
  .message(
    '"{#label}" must contain one letter, one number, and one special character.'
  )
  .required();
const passwordConfirmation = Joi.valid(Joi.ref("password")).required();

export const registerSchema = Joi.object({
  email,
  name,
  password,
  passwordConfirmation,
});
