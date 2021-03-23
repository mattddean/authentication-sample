import React from "react";
import { Form, FormField, Button, Box, TextInput } from "grommet";
import { NavLink as Link } from "react-router-dom";

export const Login = () => {
  const [value, setValue] = React.useState({});
  return (
    <Form
      value={value}
      onChange={(nextValue: React.SetStateAction<any>) => setValue(nextValue)}
      onReset={() => setValue({})}
      onSubmit={({ value }) => {
        console.log(value);
      }}
    >
      <FormField name="name" htmlFor="text-input-id" label="Username">
        <TextInput id="text-input-id" name="name" />
      </FormField>
      <FormField name="name" htmlFor="text-input-id" label="Password">
        <TextInput id="text-input-id" name="name" />
      </FormField>
      <Box direction="row" gap="medium">
        <Link to="/signup">
          <small>New here? Create an account</small>
        </Link>
      </Box>
      <Box direction="row" gap="medium">
        <Button type="submit" primary label="Submit" />
      </Box>
    </Form>
  );
};
