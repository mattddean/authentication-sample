import React from "react";
import { Box } from "grommet";
import { UserMenu } from "./UserMenu";

export const AppBar = (props: any) => {
  return (
    <Box
      tag="header"
      direction="row"
      align="center"
      justify="between"
      background="brand"
      pad={{ left: "medium", right: "small", vertical: "small" }}
      elevation="medium"
      style={{ zIndex: 1 }}
      {...props}
    >
      {props.children}
      <UserMenu></UserMenu>
    </Box>
  );
};
