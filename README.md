# luncheon-frontend

## Requirements

Install [npm](https://www.npmjs.com/) and the run:

```shell
npm install -g grunt-cli
npm install -g bower
```

## Quickstart

```shell
npm install
bower install
grunt serve
```

Above will install or update all dependencies and start client at `http://localhost:9000`.

To run local REST API emulation, run this:

```
node rest.js
```

This will start REST server at `http://localhost:3000`. Login username is `admin` and password is `admin`. 
Our server will generate some random data, so do not be terrified by lunches with names like `name animal beyond window officer bicycle throughout however` :smile:. 
POST modifications of data is not implemented in out REST emulator (I am too lazy for this), so it will just handle routes and log POST body to console.