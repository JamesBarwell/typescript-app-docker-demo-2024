import assert from "node:assert/strict";
import Koa from "koa";
import supertest from "supertest";

import appInit from "../src/app.js";
import type { Config } from "../src/utilities/config.js";
import Logger from "../src/utilities/logger.js";

describe("my app", () => {
  let app: Koa;

  beforeEach(() => {
    const config = {} as Config;

    const logger = {
      info: () => {},
    } as Logger;

    app = appInit(logger, config);
  });

  it("should test ok", async () => {
    const res = await supertest(app.callback()).get("/");
    assert.equal(res.text.trim(), "Hello world");
  });
});
