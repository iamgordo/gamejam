default: compile

compile:
	mkdir -p build
	mkdir -p bin
	cd build; cmake ..; make -j$(shell nproc)

run: compile
	./bin/noisyhunter

package-win32:
	rm -rf build-win32
	mkdir build-win32
	cd build-win32; i686-w64-mingw32-cmake ..; make -j$(shell nproc)
	cp /usr/i686-w64-mingw32/bin/SDL2.dll bin/
	cp /usr/i686-w64-mingw32/bin/SDL2_image.dll bin/
	cp /usr/i686-w64-mingw32/bin/SDL2_ttf.dll bin/
	cp /usr/i686-w64-mingw32/bin/SDL2_mixer.dll bin/
	cp /usr/i686-w64-mingw32/bin/libgcc_s_sjlj-1.dll bin/
	cp /usr/i686-w64-mingw32/bin/libstdc++-6.dll bin/
	cp /usr/i686-w64-mingw32/bin/zlib1.dll bin/
	cp /usr/i686-w64-mingw32/bin/libpng16-16.dll bin/
	cp /usr/i686-w64-mingw32/bin/libwinpthread-1.dll bin/
	cp /usr/i686-w64-mingw32/bin/libfreetype-6.dll bin/

clean:
	rm -rf build
	rm -rf bin

clang:
	cd build; rm -r *; CXX=clang++ cmake .. ; make 
