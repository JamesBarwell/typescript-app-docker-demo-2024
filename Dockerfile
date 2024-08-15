FROM node:22-alpine AS deps

ENV NODE_ENV=production
WORKDIR /tmp
COPY app .
RUN npm ci --no-fund --ignore-scripts


FROM node:22-alpine AS build

WORKDIR /tmp
COPY app .
RUN npm install typescript@^5.5.3
RUN npm run build


FROM node:22-alpine

ENV NODE_ENV=production
EXPOSE 80
WORKDIR /home/node/app
COPY app/package.json ./
COPY --from=deps /tmp/node_modules ./node_modules
COPY --from=build /tmp/build/src ./src
COPY app/public ./public
COPY app/src/views ./src/views


USER node
CMD ["npm", "run", "start-prod"]
