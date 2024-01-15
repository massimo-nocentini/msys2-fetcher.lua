
mkdir -p curl-sandbox
cd curl-sandbox
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-curl
cd temp
rm -rf .* *.sig *.tar *.zst
zip -r ../../curl.zip ./*
cd ../../
rm -rf curl-sandbox