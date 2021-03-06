import os,sys,glob

if os.name is not "nt":
	sys.exit("Do not run this on non-Win32! You are more lucky, just use your package manager to install the dependencies for you.")

from distutils.core import setup
import py2exe
import OpenGL

origIsSystemDLL = py2exe.build_exe.isSystemDLL
def isSystemDLL(pathname):
        if os.path.basename(pathname).lower() in ("libogg-0.dll", "sdl_ttf.dll", "msvcp71.dll", "dwmapi.dll"):
                return 0
        return origIsSystemDLL(pathname)
py2exe.build_exe.isSystemDLL = isSystemDLL

if int(OpenGL.__version__[0]) > 2:
  extraIncludes = [
    "OpenGL.arrays.ctypesarrays",
    "OpenGL.arrays.numpymodule",
    "OpenGL.arrays.lists",
    "OpenGL.arrays.numbers",
    "OpenGL.arrays.strings",  #stump: needed by shader code
  ]
  if os.name == 'nt':
    extraIncludes.append("OpenGL.platform.win32")

setup(windows=[{"script":"src/main.py"}],
      options={"py2exe":{"includes":extraIncludes}},
      packages=[""],
      package_dir={"":"src"},
      data_files=[("gfx", glob.glob("gfx/*")),
                  ("snd", glob.glob("snd/*"))],
      )

 
