-include .env

.PHONY: all test deploy

all: build

install:
	forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit && forge install Cyfrin/foundry-devops --no-commit

test:
	forge test

build:
	forge build

format:
	forge fmt

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account default --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy-basic-nft:
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft $(NETWORK_ARGS)

deploy-mood-nft:
	@forge script script/DeployMoodNft.s.sol:DeployMoodNft $(NETWORK_ARGS)

mint_default_token_uri_nft:
	@forge script script/Interactions.s.sol:Interactions --sig "run(string)" "" $(NETWORK_ARGS)

mint_nft_with_custom_token_uri:
	@forge script script/Interactions.s.sol:Interactions --sig "run(string)" $(TOKEN_URI) $(NETWORK_ARGS)
