import env from "env-var";

const httpPort = env.get("HTTP_PORT").default(8080).asInt();

const config = {
  httpPort,
};

export default config;
export type Config = typeof config;
