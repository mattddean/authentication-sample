import React from "react";
import { Grommet, Heading, Box, DropButton } from "grommet";
import { AppBar } from "./components/AppBar";
import { BrowserRouter as Router, Route, Switch, Link } from "react-router-dom";
import { Login } from "./pages/Login";
import { User } from "./pages/User";
import { CreateAccount } from "./pages/CreateAccount";
import { DropButtonLink } from "./components/DropButtonLink";

const theme = {
  global: {
    font: {
      family: "Roboto",
      size: "18px",
      height: "20px",
    },
  },
};

function App() {
  return (
    <Grommet theme={theme} full>
      <Router>
        <AppBar>
          <Heading level="3" margin="none">
            Authentication Sample
          </Heading>
          <DropButton
            label="User's Name"
            dropAlign={{ top: "bottom", right: "right" }}
            dropContent={
              <Box>
                <DropButtonLink label="Logout"></DropButtonLink>
                <Link to="/profile">
                  <DropButtonLink label="Profile"></DropButtonLink>
                </Link>
              </Box>
            }
          />
        </AppBar>
        <Box direction="row" flex overflow={{ horizontal: "hidden" }}>
          <Box flex align="center" justify="center">
            <Switch>
              <Route exact path="/">
                <Login />
              </Route>
              <Route path="/profile">
                <User />
              </Route>
              <Route path="/signup">
                <CreateAccount />
              </Route>
            </Switch>
          </Box>
        </Box>
      </Router>
    </Grommet>
  );
}

export default App;
