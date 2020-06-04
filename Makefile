OK_COLOR     = \033[0;32m
NO_COLOR     = \033[m

DOCKER_USER = kgrondin01
DOCKER_IMAGE_PREFIX = $(DOCKER_USER)/meteor-test

TAG_LATEST = latest
TAG ?= 1.0.1

# development docker-compose
COMPOSE              = docker-compose
COMPOSE_RUN          = $(COMPOSE) run --rm

# production docker-compose
COMPOSEPROD          = docker-compose -f ./docker-compose.yml -f ./docker-compose.prod.yml

# kubernetes
# KUBECTL_CONFIG       = -f ./deployments/api.yml -f ./deployments/front.yml

default: help

docker-images: ## List project's docker images
	@docker images --filter=reference='$(DOCKER_IMAGE_PREFIX)*'

docker-images-name: ## List project's docker images formatted as <name>:<tag>
	@docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference='$(DOCKER_IMAGE_PREFIX)*'

docker-images-id: ## List project's docker images formatted as <id>
	@docker images --quiet --filter=reference='$(DOCKER_IMAGE_PREFIX)*'

docker-images-clean: ## Clean dangling images (tagged as <none>)
	docker rmi $(shell docker images -q --filter="dangling=true")

docker-build-prod: ## Build production images
	docker build ./meteor/test-app -t $(DOCKER_IMAGE_PREFIX):$(TAG)

dev-start: ## 🐳  Start development stack
	$(COMPOSE) up
dev-start-d: ## Start development stack (in daemon mode)
	$(COMPOSE) up -d
dev-stop: ## Stop development stack
	$(COMPOSE) down
dev-ps: ## List development stack active containers
	$(COMPOSE) ps
dev-logs: ## 🐳  Follow ALL logs (dev)
	$(COMPOSE) logs -f
dev-logs-mongo: ## Follow front logs (dev)
	$(COMPOSE) logs -f mongo
dev-logs-meteor: ## Follow api logs (dev)
	$(COMPOSE) logs -f meteor

prod-start: ## 🐳  Start production stack (bundles frontend before)
	$(COMPOSEPROD) up --build
prod-start-d: ## Start production stack (in daemon mode)
	$(COMPOSEPROD) up --build -d
prod-start-no-rebuild: ## 🐳  Start production stack without recreating docker images
	$(COMPOSEPROD) up
prod-start-d-no-rebuild: ## Start production stack (in daemon mode)  without recreating docker images
	$(COMPOSEPROD) up -d
prod-stop: ## Stop production stack
	$(COMPOSEPROD) down
prod-ps: ## List production stack active containers
	$(COMPOSEPROD) ps
prod-logs: ## 🐳  Follow ALL logs (prod)
	$(COMPOSEPROD) logs -f
prod-logs-mongo: ## Follow front logs (prod)
	$(COMPOSEPROD) logs -f mongo
prod-logs-meteor: ## Follow api logs (prod)
	$(COMPOSEPROD) logs -f meteor

