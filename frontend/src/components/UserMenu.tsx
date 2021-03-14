import React from "react";
import { Box, Menu, Text } from "grommet";
import { Logout, Github, FormDown } from "grommet-icons";
import { Redirect } from "react-router-dom";

export const UserMenu = (props: any) => {
  const [toProfile, setToProfile] = React.useState(false);

  const logout = () => {
    console.log("logging out");
  };

  if (toProfile === true) {
    return <Redirect to="/profile" />;
  }

  return (
    <Menu
      plain
      items={[
        {
          label: <Box alignSelf="center">Github</Box>,
          onClick: () => setToProfile(true),
          icon: (
            <Box pad="medium">
              <Github size="medium" />
            </Box>
          ),
        },
        {
          label: <Box alignSelf="center">Logout</Box>,
          onClick: () => logout(),
          icon: (
            <Box pad="medium">
              <Logout size="medium" />
            </Box>
          ),
        },
      ]}
      {...props}
    >
      <Box direction="row" gap="small" pad="medium">
        <FormDown />
        <Text>User&apos;s Name</Text>
      </Box>
    </Menu>
  );
};
