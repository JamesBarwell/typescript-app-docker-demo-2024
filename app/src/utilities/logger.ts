type LogParameter = string | number | { [key: string]: any };

class Logger {
  log(level: string, ...args: LogParameter[]): void {
    const logFunc = process.stdout.write.bind(process.stdout);

    const now = new Date().toISOString();

    const output = args
      .map((arg) => {
        if (typeof arg === "object") {
          return JSON.stringify(arg);
        }
        return arg;
      })
      .join(" ");

    logFunc(`${now} ${level} ${output}\n`);
  }

  info(...args: LogParameter[]): void {
    return this.log("info", ...args);
  }

  warn(...args: LogParameter[]): void {
    return this.log("warn", ...args);
  }

  error(...args: LogParameter[]): void {
    return this.log("error", ...args);
  }
}

export default Logger;
