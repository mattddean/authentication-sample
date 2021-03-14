import React from "react";
import { Box, Button, Text } from "grommet";

type DropButtonLinkProps = {
  label: string;
};

export const DropButtonLink = ({ label }: DropButtonLinkProps) => {
  return (
    <Button key={label} hoverIndicator={true}>
      <Box
        direction="row"
        justify="between"
        align="center"
        pad={{ horizontal: "small", vertical: "xsmall" }}
      >
        <Text>{label}</Text>
      </Box>
    </Button>
  );
};
