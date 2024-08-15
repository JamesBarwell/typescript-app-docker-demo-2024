NODE_BASE_IMAGE := node:22-alpine
NODE_BASE_INSTALL_DIR := /home/node/app
IMAGE_NAME := tsapp2024
APP_DIR=$(shell pwd)/app
USER_ID=$(shell id -u)
USER_GROUP_ID=$(shell id -g)


# Orchestrated commands

pre-commit: check-fix test
pre-deploy: check test-prod dependencies-audit build


# Dev env

dev-env:
	./i3-env.sh


# Build

build:
	docker run -t --rm --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run build

build-watch:
	docker run -t --rm --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run build-watch

docker-build:
	docker build -t ${IMAGE_NAME} .

clean:
	rm app/build app/coverage -rf


# Run application

run-prod:
	docker run --rm --init -p 8080:8080 -e NODE_ENV=production ${IMAGE_NAME}

run-dev:
	docker run --rm --init -p 8080:8080 -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run start-dev


# Dependencies

dependencies-install:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm install --no-fund --ignore-scripts

dependencies-audit:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm audit

dependencies-audit-fix:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm audit fix

dependencies-outdated:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm outdated


# Test

test:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm test

test-watch:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run test-watch

test-prod:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run test-prod

test-coverage:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run coverage


# Code quality

lint:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run lint

lint-fix:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run lint-fix

format:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run format

format-fix:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run format-fix

check:
	docker run --rm -t --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR}:ro -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run check

check-fix:
	docker run --rm -t --user ${USER_ID}:${USER_GROUP_ID} --init -v ${APP_DIR}:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run check-fix


# Code analysis

line-count:
	find app/src app/test -name "*.ts" -exec wc -l {} +
