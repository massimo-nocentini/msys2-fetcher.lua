
mkdir -p pharo-goodies-sandbox
cd pharo-goodies-sandbox
mkdir temp
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-cairo mingw-w64-ucrt-x86_64-poppler mingw-w64-ucrt-x86_64-pango mingw-w64-ucrt-x86_64-curl mingw-w64-ucrt-x86_64-libgit2 mingw-w64-ucrt-x86_64-lua mingw-w64-ucrt-x86_64-tree-sitter mingw-w64-ucrt-x86_64-gdk-pixbuf2
cd temp
rm -rf .* *.sig *.tar *.zst
zip -r ../../pharo-goodies.zip ./*
cd ../../
# rm -rf pharo-goodies-sandbox