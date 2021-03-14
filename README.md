# Authentication Sample

## How this repo was set up

(No need to run these commands; just here for posterity.)

```bash
npx create-react-app authentication-sample --template typescript --use-npm
```

## Set up your frontend development environment

### Local Dependencies
- Docker

### Setup

```bash
CURRENT_USER_ID=$(id -u) CURRENT_GROUP_ID=$(id -g) docker-compose build frontend
docker-compose run --rm frontend bash
npm install # install packages for frontend app in container and node_modules/.bin exectuables for host (like eslint)
exit
```

### Serve React on host port 8000

```bash
docker-compose up frontend
```

> Warnings about CURRENT_USER_ID and CURRENT_GROUP_ID variables not being set can be safely ignored. These were only used during the image build process, not the container run process.

Then navigate to http://localhost:8000 to see the frontend

### Run bash commands in frontned dev environment

```bash
docker-compose up frontend # (if it's not already up)
```

In a separate shell
```bash
docker-compose exec frontend bash
# and run the npm, etc. commands you need to run the shell that just opened
```

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.\
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).
