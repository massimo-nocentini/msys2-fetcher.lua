
mkdir -p libgit2-sandbox
cd libgit2-sandbox
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-libgit2
cd temp
rm -rf .* *.sig *.tar *.zst
zip -r ../../libgit2.zip ./*
cd ../../
rm -rf libgit2-sandbox