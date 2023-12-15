
mkdir -p ucrt64-gtk3-sandbox
cd ucrt64-gtk3-sandbox
lua ../../src/msys2-fetcher.lua mingw-w64-ucrt-x86_64-gtk3
zip -r ../ucrt64-gtk3.zip temp/ucrt64/*
cd ..
#rm -rf ucrt64-gtk3-sandbox