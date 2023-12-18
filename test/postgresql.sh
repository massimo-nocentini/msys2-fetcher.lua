
mkdir -p postgresql-sandbox
cd postgresql-sandbox
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-postgresql
cd temp
rm -rf .* *.sig *.tar *.zst
zip -r ../../postgresql.zip ./*
cd ../../
rm -rf postgresql-sandbox