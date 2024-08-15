import Router from "@koa/router";

export default function setupPagesController(router: Router) {
  router.get("/", (ctx, next) => {
    return ctx.render("index", {
      name: "world",
    });
  });
}
