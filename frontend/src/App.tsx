import React from "react";
import { Grommet, Heading, Box } from "grommet";
import { AppBar } from "./components/AppBar";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { Login } from "./pages/Login";
import { Profile } from "./pages/Profile";
import { CreateAccount } from "./pages/CreateAccount";

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
        </AppBar>
        <Box direction="row" flex overflow={{ horizontal: "hidden" }}>
          <Box flex align="center" justify="center">
            <Switch>
              <Route exact path="/">
                <Login />
              </Route>
              <Route path="/profile">
                <Profile />
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
