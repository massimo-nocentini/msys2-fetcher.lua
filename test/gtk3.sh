
mkdir -p gtk3-sandbox
cd gtk3-sandbox
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-gtk3 mingw-w64-ucrt-x86_64-poppler
cd temp
rm -rf .* *.sig *.tar *.zst
zip -r ../../gtk3.zip ./*
cd ../../
rm -rf gtk3-sandbox