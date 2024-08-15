Typescript App Docker Demo 2024
---

Example project to test and document an up to date way of developing typescript/node apps.

I have been developing Node apps in the same way for many years. I wanted to re-examine my choices and establish a modern development workflow and architecture.

## Goals

The Javascript ecosystem is infamous for being in a permanent cycle of re-inventing dev tooling, leading to immature solutions and volatility. With Typscript in particular, I was previously put off because of the bad tooling and slow compilation times. One of the main goals here is to understand whether it's possible to have an easy to use and no-fuss Typescript development process. For me this means that tooling needs to work correctly, and that the application, tests and compiler must re-run almost instantly after making changes.

The Javascript ecosystem is also - perhaps a little unfairly - infamous for relying on ridiculous amounts of third-party dependencies in order to achieve the simplest tasks. This mess of third party code is disconcerting and can lead to security issues. Another goal of this project is to see how well these can be reduced to a small trusted set.


## How to use

- Copy `config.env.example` to `config.env`.
- `make dependencies-install` to download dependencies
- `make run-dev` to start server
- Or alternatively, the "dev environment" can be started with `make dev-env`
- See the `Makefile` for all commands


## Decisions
---

### Node vs alternative run times

A lot of the "batteries included" choices I've made here are being tackled by alternative run times such as Deno or Bun.

I chose to stick with Node mainly because it is the most mature and well adopted, and I wanted to see if the tooling can play well together without switching.

### Typescript

In development I use `tsx` to run the code and tests. `tsx` transforms Typescript code to Javascript to run in Node, but does no type checking. Previously I have used `ts-node` but have always found it difficult to configure with other tooling, and slow. `tsx` worked here out of the box.

While developing, I use `tsc` in watch mode to check for compilation errors.

It seems odd running two different Typescript processes simultaneously but they are each doing different things.

### Web framework

I evaluated Hapi, Koa and Express.

One of the main pain points with these frameworks and Typescript is that they work by enriching a request object at runtime using various middlewares. This can either create annoyances for typing, or leave the objects untyped and prone to errors.

I liked the Hapi ecosystem which is comprehensive, but ultimately found I was spending too much time messing around simply to satisfy the Typescript compiler. The Hapi router/controller set up is very explicit but also rather verbose compared to other frameworks.

There seemed to be little to choose between Express and Koa, which are built by the same developers. Ultimately I went with Koa as it has a more minimalistic approach. It largely plays well with Typescript but still has issues, such as being able to typo method calls on the `ctx` object.

### Linting/formatting

I have used ESLint and Prettier for many years. I switched to Biome as it is much faster and is a single dependency.

One downside with Biome is that it is not very opinionated/strict out of the box, so it's important to examine the rules documentation and configure it as you see fit.

### Testing

I am using Mocha as it is well-established, mature and fast. It works easily with `tsx`.

I have also used Jest in the past but find it very slow to execute tests, and bloated in features.

I tried out Node's built-in test runner and hoped to switch to that in order to reduce dependencies. However it is immature and has various issues:
* Test watch mode does not work with `--watch-path`. This means that the test runner cannot watch your source files, and cannot re-run tests when changing your implementation.
* When developing tests you may want to use 'only' to narrow down test execution. In Mocha, setting this causes only that test/suite to run, and removing it allows everything to run. This means you can flexibly use it and remove it when developing tests. Using Node's built-in runner, a command line option must be passed to use 'only', and that option always prevents 'non-only' tests running. This is awkward to use as if you wish to switch back and forth between using 'only' and not, you'd need to restart the test runner with different command options each time.
* Test execution is slow compared to Mocha.

### Test coverage

Node's built in test coverage can be accessed using `--experimental-test-coverage`. Unfortuantely this does not pick up all source files, despite using the `--test-coverage-include` option. I am using `c8` instead.


## What else is demonstrated

* Developing inside a Docker container, with hot-reload.
* Example tests.
* Use of official Node Docker image.
* Docker multi-stage build.
* Use of code quality tools: including linting, formatting and code coverage.
* An example terminal based "development environment"


## Explanation of the core concepts

### Developing inside a Docker container

There are some potential advantages to being able to run code in the container while developing:
* develop the code in the same environment as it will run in production.
* easily connect to other docker services, for example a database, using docker networking.
* paves the way to bringing up an entire stack of services using docker-compose.

You can of course continue to run the code directly on the host machine without docker.

### Test approach

Demonstrate use of the test framework and automatic re-run.

The test demonstrates a simple solution to mocking that is Typescript compatible and does not use a mocking library. Mock instances are created and passed around. Casting is used to avoid having to mock an entire object where only some implementation is required.

### Multi-stage build

The docker build is carried out using a multi-stage build process. This creates additional temporary container environments that are used to run the build. At the end, artefacts from the build are copied into the deployable container, creating a production artefact.

In a Typescript application this is particularly useful as it keeps the source code out of the distributed package. Only the built code and the production `node_modules` will be packaged.

### Linter and code coverage

The linter/formatted will ensure code-style consistency and catch errors that the compilar may miss.

The code coverage can provide some clues as to areas of the code that may require additional test coverage.

### Makefile

Provides an example of how the container should be built and run.

The commands included here could perhaps remove the need for a proper CI tool in the early stages of a project. When CI is required, the commands can just be called by the CI tool, so the CI configuration does not require any special knowledge of how to build the project other than the name of the command.

### Dev environment using i3

A simple script is included to run a simple and minimal "dev environment", which runs vim, the application, tests and compiler. Everyone will have their own preferences for how they develop, and this is merely intended to demonstrate the benefits of having everything able to run independently.

## Misc

* `npm install` is run with the `--ignore-scripts` flag, which prevents dependencies and their sub-dependencies from running scripts. This removes the most serious attack vector with npm, however it may break dependencies that rely on install scripts to function. Remove this flag at your own peril.
