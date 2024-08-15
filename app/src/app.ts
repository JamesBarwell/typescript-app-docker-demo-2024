import Router from "@koa/router";
import Koa from "koa";
import serve from "koa-static";
import views from "koa-views";

import setupPagesController from "./pagesController.js";
import type { Config } from "./utilities/config.js";
import Logger from "./utilities/logger.js";

export default function appInit(logger: Logger, config: Config) {
  const app = new Koa();
  const router = new Router();

  app.use(
    views("./src/views", {
      map: {
        html: "handlebars",
      },
    }),
  );

  app.use(async (ctx, next) => {
    await next();
    const rt = ctx.response.get("X-Response-Time");
    logger.info(`${ctx.method} ${ctx.url} - ${rt}`);
  });

  app.use(async (ctx, next) => {
    const start = Date.now();
    await next();
    const ms = Date.now() - start;
    ctx.set("X-Response-Time", `${ms}ms`);
  });

  setupPagesController(router);

  app.use(router.routes()).use(router.allowedMethods());

  app.use(serve("./public"));

  return app;
}
