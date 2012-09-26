CMAKE_MINIMUM_REQUIRED(VERSION 2.6 FATAL_ERROR)
CMAKE_POLICY(VERSION 2.6)
FIND_PACKAGE(Torch REQUIRED)

SET(src)
SET(luasrc util/init.lua util/warn.lua util/file.lua util/arg.lua util/queue.lua)

ADD_TORCH_PACKAGE(util "${src}" "${luasrc}" "Collection of utilities.")

