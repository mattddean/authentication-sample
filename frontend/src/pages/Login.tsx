import React, { useState } from "react";
import { Form, FormField, Button, Box, TextInput } from "grommet";
import { NavLink as Link } from "react-router-dom";
import { useUserContext } from "../hooks/useUserContext";
import { UserContext } from "../contexts/UserContext";
import { useUserContextValue } from "../hooks/useUserContextValue";

export const Login = () => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const userContextValue = useUserContextValue(); // get user data
  const { login } = useUserContext(); // update user data
  return (
    <Form
      onReset={() => {
        setFirstName("");
      }}
      onSubmit={({ value }) => {
        console.log(value);
        login(value.email, value.password);
      }}
    >
      <FormField name="firstName" htmlFor="text-input-id" label="First Name">
        <TextInput
          id="text-input-id"
          name="name"
          value={firstName}
          onChange={(newVal: React.ChangeEvent<HTMLInputElement>) => {
            setFirstName(newVal.target.value);
          }}
        />
      </FormField>
      <FormField name="lastName" htmlFor="text-input-id" label="Last Name">
        <TextInput
          id="text-input-id"
          name="name"
          value={lastName}
          onChange={(newVal: React.ChangeEvent<HTMLInputElement>) => {
            setLastName(newVal.target.value);
          }}
        />
      </FormField>
      <FormField name="name" htmlFor="text-input-id" label="Email">
        <TextInput
          id="text-input-id"
          name="username"
          value={email}
          onChange={(newVal: React.ChangeEvent<HTMLInputElement>) => {
            setEmail(newVal.target.value);
          }}
        />
      </FormField>
      <FormField name="name" htmlFor="text-input-id" label="Password">
        <TextInput
          id="text-input-id"
          name="name"
          value={password}
          onChange={(newVal: React.ChangeEvent<HTMLInputElement>) => {
            setPassword(newVal.target.value);
          }}
        />
      </FormField>
      <Box direction="row" gap="medium">
        <Link to="/signup">
          <small>New here? Create an account</small>
        </Link>
      </Box>
      <Box direction="row" gap="medium">
        <UserContext.Provider value={userContextValue}>
          <Button type="submit" primary label="Submit" />
        </UserContext.Provider>
      </Box>
    </Form>
  );
};
