import React from "react";
import { Grommet, Heading, Button, Box } from "grommet";
import { AppBar } from "./components/AppBar";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { Login } from "./pages/Login";
import { User } from "./pages/User";
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
      <AppBar>
        <Heading level="3" margin="none">
          Authentication Sample
        </Heading>
        <Button label="User's Name" onClick={() => {}} />
      </AppBar>
      <Box direction="row" flex overflow={{ horizontal: "hidden" }}>
        <Box flex align="center" justify="center">
          <Router>
            <Switch>
              <Route exact path="/">
                <Login />
              </Route>
              <Route path="/user">
                <User />
              </Route>
              <Route path="/signup">
                <CreateAccount />
              </Route>
            </Switch>
          </Router>
        </Box>
      </Box>
    </Grommet>
  );
}

export default App;
