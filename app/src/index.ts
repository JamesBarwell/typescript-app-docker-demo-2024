import appInit from "./app.js";
import config from "./utilities/config.js";
import Logger from "./utilities/logger.js";

const logger = new Logger();

const httpPort = config.httpPort;

const app = appInit(logger, config);

app.on("error", (err) => {
  console.error("server error", err);
});

app.listen(httpPort);
logger.info(`Listening on port ${httpPort}`);
