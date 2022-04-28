rm -rf ethtest

mkdir -p bsctest/data

geth --syncmode=full --nodiscover --datadir bsctest/data init genesis.json

geth --datadir bsctest/data account new

cp genesis.json bsctest/data/geth/chaindata/
