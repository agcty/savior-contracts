forge create src/Donations.sol:Donations --optimize --private-key "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" --chain=1335

forge create test/CharitableNFT.t.sol:NFT --optimize --private-key "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" --chain=1335 --constructor-args "TestNFT" "TST" "0x5fbdb2315678afecb367f032d93f642f64180aa3"