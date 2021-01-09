 {.deadCodeElim: on.}
when defined(windows):
  const
    raylibdll = "libraylib.dll"
elif defined(macosx):
  const
    raylibdll = "libraylib.dylib"
else:
  const
    raylibdll = "libraylib.so"
# Functions on C varargs
# Used only for TraceLogCallback type, see core_custom_logging example
type va_list* {.importc: "va_list", header: "<stdarg.h>".} = object
proc vprintf*(format: cstring, args: va_list) {.cdecl, importc: "vprintf", header: "<stdio.h>"}
## *********************************************************************************************
##
##    raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
##
##    FEATURES:
##        - NO external dependencies, all required libraries included with raylib
##        - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly, MacOS, UWP, Android, Raspberry Pi, HTML5.
##        - Written in plain C code (C99) in PascalCase/camelCase notation
##        - Hardware accelerated with OpenGL (1.1, 2.1, 3.3 or ES2 - choose at compile)
##        - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
##        - Multiple Fonts formats supported (TTF, XNA fonts, AngelCode fonts)
##        - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
##        - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
##        - Flexible Materials system, supporting classic maps and PBR maps
##        - Skeletal Animation support (CPU bones-based animation)
##        - Shaders support, including Model shaders and Postprocessing shaders
##        - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
##        - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, XM, MOD)
##        - VR stereo rendering with configurable HMD device parameters
##        - Bindings to multiple programming languages available!
##
##    NOTES:
##        One custom font is loaded by default when InitWindow() [core]
##        If using OpenGL 3.3 or ES2, one default shader is loaded automatically (internally defined) [rlgl]
##        If using OpenGL 3.3 or ES2, several vertex buffers (VAO/VBO) are created to manage lines-triangles-quads
##
##    DEPENDENCIES (included):
##        [core] rglfw (github.com/glfw/glfw) for window/context management and input (only PLATFORM_DESKTOP)
##        [rlgl] glad (github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading (only PLATFORM_DESKTOP)
##        [raudio] miniaudio (github.com/dr-soft/miniaudio) for audio device/context management
##
##    OPTIONAL DEPENDENCIES (included):
##        [core] rgif (Charlie Tangora, Ramon Santamaria) for GIF recording
##        [textures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
##        [textures] stb_image_write (Sean Barret) for image writting (BMP, TGA, PNG, JPG)
##        [textures] stb_image_resize (Sean Barret) for image resizing algorithms
##        [textures] stb_perlin (Sean Barret) for Perlin noise image generation
##        [text] stb_truetype (Sean Barret) for ttf fonts loading
##        [text] stb_rect_pack (Sean Barret) for rectangles packing
##        [models] par_shapes (Philip Rideout) for parametric 3d shapes generation
##        [models] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
##        [models] cgltf (Johannes Kuhlmann) for models loading (glTF)
##        [raudio] stb_vorbis (Sean Barret) for OGG audio loading
##        [raudio] dr_flac (David Reid) for FLAC audio file loading
##        [raudio] dr_mp3 (David Reid) for MP3 audio file loading
##        [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
##        [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
##
##
##    LICENSE: zlib/libpng
##
##    raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
##    BSD-like license that allows static linking with closed source software:
##
##    Copyright (c) 2013-2021 Ramon Santamaria (@raysan5)
##
##    This software is provided "as-is", without any express or implied warranty. In no event
##    will the authors be held liable for any damages arising from the use of this software.
##
##    Permission is granted to anyone to use this software for any purpose, including commercial
##    applications, and to alter it and redistribute it freely, subject to the following restrictions:
##
##      1. The origin of this software must not be misrepresented; you must not claim that you
##      wrote the original software. If you use this software in a product, an acknowledgment
##      in the product documentation would be appreciated but is not required.
##
##      2. Altered source versions must be plainly marked as such, and must not be misrepresented
##      as being the original software.
##
##      3. This notice may not be removed or altered from any source distribution.
##
## ********************************************************************************************

## ----------------------------------------------------------------------------------
##  Some basic Defines
## ----------------------------------------------------------------------------------
##  Allow custom memory allocators
##  NOTE: MSC C++ compiler does not support compound literals (C99 feature)
##  Plain structures in C++ (without constructors) can be initialized from { } initializers.
##  Some Basic Colors
##  NOTE: Custom raylib color palette for amazing visuals on WHITE background
##  Temporal hack to avoid breaking old codebases using
##  deprecated raylib implementation of these functions
## #define Fade(c, a)  ColorAlpha(c, a)
## ----------------------------------------------------------------------------------
##  Structures Definition
## ----------------------------------------------------------------------------------
##  Boolean type
##  Vector2 type

type
  Vector2* {.bycopy.} = tuple
    x: cfloat
    y: cfloat


##  Vector3 type

type
  Vector3* {.bycopy.} = tuple
    x: cfloat
    y: cfloat
    z: cfloat


##  Vector4 type

type
  Vector4* {.bycopy.} = tuple
    x: cfloat
    y: cfloat
    z: cfloat
    w: cfloat


##  Quaternion type, same as Vector4

type
  Quaternion* = Vector4

##  Matrix type (OpenGL style 4x4 - right handed, column major)

type
  Matrix* {.bycopy.} = tuple
    m0: cfloat
    m4: cfloat
    m8: cfloat
    m12: cfloat
    m1: cfloat
    m5: cfloat
    m9: cfloat
    m13: cfloat
    m2: cfloat
    m6: cfloat
    m10: cfloat
    m14: cfloat
    m3: cfloat
    m7: cfloat
    m11: cfloat
    m15: cfloat


##  Color type, RGBA (32bit)

type
  Color* {.bycopy.} = tuple
    r: uint8
    g: uint8
    b: uint8
    a: uint8


##  Rectangle type

type
  Rectangle* {.bycopy.} = tuple
    x: cfloat
    y: cfloat
    width: cfloat
    height: cfloat


##  Image type, bpp always RGBA (32bit)
##  NOTE: Data stored in CPU memory (RAM)

type
  Image* {.bycopy.} = object
    data*: pointer             ##  Image raw data
    width*: cint               ##  Image base width
    height*: cint              ##  Image base height
    mipmaps*: cint             ##  Mipmap levels, 1 by default
    format*: cint              ##  Data format (PixelFormat type)


##  Texture type
##  NOTE: Data stored in GPU memory

type
  Texture* {.bycopy.} = object
    id*: cuint                 ##  OpenGL texture id
    width*: cint               ##  Texture base width
    height*: cint              ##  Texture base height
    mipmaps*: cint             ##  Mipmap levels, 1 by default
    format*: cint              ##  Data format (PixelFormat type)


##  Texture2D type, same as Texture

type
  Texture2D* = Texture

##  TextureCubemap type, actually, same as Texture

type
  TextureCubemap* = Texture

##  RenderTexture type, for texture rendering

type
  RenderTexture* {.bycopy.} = object
    id*: cuint                 ##  OpenGL Framebuffer Object (FBO) id
    texture*: Texture          ##  Color buffer attachment texture
    depth*: Texture            ##  Depth buffer attachment texture


##  RenderTexture2D type, same as RenderTexture

type
  RenderTexture2D* = RenderTexture

##  N-Patch layout info

type
  NPatchInfo* {.bycopy.} = object
    source*: Rectangle         ##  Region in the texture
    left*: cint                ##  left border offset
    top*: cint                 ##  top border offset
    right*: cint               ##  right border offset
    bottom*: cint              ##  bottom border offset
    `type`*: cint              ##  layout of the n-patch: 3x3, 1x3 or 3x1


##  Font character info

type
  CharInfo* {.bycopy.} = object
    value*: cint               ##  Character value (Unicode)
    offsetX*: cint             ##  Character offset X when drawing
    offsetY*: cint             ##  Character offset Y when drawing
    advanceX*: cint            ##  Character advance position X
    image*: Image              ##  Character image data


##  Font type, includes texture and charSet array data

type
  Font* {.bycopy.} = object
    baseSize*: cint            ##  Base size (default chars height)
    charsCount*: cint          ##  Number of characters
    charsPadding*: cint        ##  Padding around the chars
    texture*: Texture2D        ##  Characters texture atlas
    recs*: ptr Rectangle        ##  Characters rectangles in texture
    chars*: ptr CharInfo        ##  Characters info data


##  Camera type, defines a camera position/orientation in 3d space

type
  Camera3D* {.bycopy.} = object
    position*: Vector3         ##  Camera position
    target*: Vector3           ##  Camera target it looks-at
    up*: Vector3               ##  Camera up vector (rotation over its axis)
    fovy*: cfloat              ##  Camera field-of-view apperture in Y (degrees) in perspective, used as near plane width in orthographic
    `type`*: cint              ##  Camera type, defines projection type: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC

  Camera* = Camera3D

##  Camera type fallback, defaults to Camera3D
##  Camera2D type, defines a 2d camera

type
  Camera2D* {.bycopy.} = object
    offset*: Vector2           ##  Camera offset (displacement from target)
    target*: Vector2           ##  Camera target (rotation and zoom origin)
    rotation*: cfloat          ##  Camera rotation in degrees
    zoom*: cfloat              ##  Camera zoom (scaling), should be 1.0f by default


##  Vertex data definning a mesh
##  NOTE: Data stored in CPU memory (and GPU)

type
  Mesh* {.bycopy.} = object
    vertexCount*: cint         ##  Number of vertices stored in arrays
    triangleCount*: cint       ##  Number of triangles stored (indexed or not)
                       ##  Default vertex data
    vertices*: ptr cfloat       ##  Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    texcoords*: ptr cfloat      ##  Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    texcoords2*: ptr cfloat     ##  Vertex second texture coordinates (useful for lightmaps) (shader-location = 5)
    normals*: ptr cfloat        ##  Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    tangents*: ptr cfloat       ##  Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    colors*: ptr uint8         ##  Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    indices*: ptr cushort ##  Vertex indices (in case vertex data comes indexed)
                       ##  Animation vertex data
    animVertices*: ptr cfloat   ##  Animated vertex positions (after bones transformations)
    animNormals*: ptr cfloat    ##  Animated normals (after bones transformations)
    boneIds*: ptr cint          ##  Vertex bone ids, up to 4 bones influence by vertex (skinning)
    boneWeights*: ptr cfloat ##  Vertex bone weight, up to 4 bones influence by vertex (skinning)
                          ##  OpenGL identifiers
    vaoId*: cuint              ##  OpenGL Vertex Array Object id
    vboId*: ptr cuint           ##  OpenGL Vertex Buffer Objects id (default vertex data)


##  Shader type (generic)

type
  Shader* {.bycopy.} = object
    id*: cuint                 ##  Shader program id
    locs*: ptr cint             ##  Shader locations array (MAX_SHADER_LOCATIONS)


##  Material texture map

type
  MaterialMap* {.bycopy.} = object
    texture*: Texture2D        ##  Material map texture
    color*: Color              ##  Material map color
    value*: cfloat             ##  Material map value


##  Material type (generic)

type
  Material* {.bycopy.} = object
    shader*: Shader            ##  Material shader
    maps*: ptr MaterialMap      ##  Material maps array (MAX_MATERIAL_MAPS)
    params*: ptr cfloat         ##  Material generic parameters (if required)


##  Transformation properties

type
  Transform* {.bycopy.} = object
    translation*: Vector3      ##  Translation
    rotation*: Quaternion      ##  Rotation
    scale*: Vector3            ##  Scale


##  Bone information

type
  BoneInfo* {.bycopy.} = object
    name*: array[32, char]      ##  Bone name
    parent*: cint              ##  Bone parent


##  Model type

type
  Model* {.bycopy.} = object
    transform*: Matrix         ##  Local transform matrix
    meshCount*: cint           ##  Number of meshes
    materialCount*: cint       ##  Number of materials
    meshes*: ptr Mesh           ##  Meshes array
    materials*: ptr Material    ##  Materials array
    meshMaterial*: ptr cint     ##  Mesh material number
                         ##  Animation data
    boneCount*: cint           ##  Number of bones
    bones*: ptr BoneInfo        ##  Bones information (skeleton)
    bindPose*: ptr Transform    ##  Bones base transformation (pose)


##  Model animation

type
  ModelAnimation* {.bycopy.} = object
    boneCount*: cint           ##  Number of bones
    frameCount*: cint          ##  Number of animation frames
    bones*: ptr BoneInfo        ##  Bones information (skeleton)
    framePoses*: ptr ptr Transform ##  Poses array by frame


##  Ray type (useful for raycast)

type
  Ray* {.bycopy.} = object
    position*: Vector3         ##  Ray position (origin)
    direction*: Vector3        ##  Ray direction


##  Raycast hit information

type
  RayHitInfo* {.bycopy.} = object
    hit*: bool                 ##  Did the ray hit something?
    distance*: cfloat          ##  Distance to nearest hit
    position*: Vector3         ##  Position of nearest hit
    normal*: Vector3           ##  Surface normal of hit


##  Bounding box type

type
  BoundingBox* {.bycopy.} = object
    min*: Vector3              ##  Minimum vertex box-corner
    max*: Vector3              ##  Maximum vertex box-corner


##  Wave type, defines audio wave data

type
  Wave* {.bycopy.} = object
    sampleCount*: cuint        ##  Total number of samples
    sampleRate*: cuint         ##  Frequency (samples per second)
    sampleSize*: cuint         ##  Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    channels*: cuint           ##  Number of channels (1-mono, 2-stereo)
    data*: pointer             ##  Buffer data pointer

  RAudioBuffer* {.bycopy.} = object


##  Audio stream type
##  NOTE: Useful to create custom audio streams not bound to a specific file

type
  AudioStream* {.bycopy.} = object
    buffer*: ptr RAudioBuffer   ##  Pointer to internal data used by the audio system
    sampleRate*: cuint         ##  Frequency (samples per second)
    sampleSize*: cuint         ##  Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    channels*: cuint           ##  Number of channels (1-mono, 2-stereo)


##  Sound source type

type
  Sound* {.bycopy.} = object
    stream*: AudioStream       ##  Audio stream
    sampleCount*: cuint        ##  Total number of samples


##  Music stream type (audio file streaming from memory)
##  NOTE: Anything longer than ~10 seconds should be streamed

type
  Music* {.bycopy.} = object
    stream*: AudioStream       ##  Audio stream
    sampleCount*: cuint        ##  Total number of samples
    looping*: bool             ##  Music looping enable
    ctxType*: cint             ##  Type of music context (audio filetype)
    ctxData*: pointer          ##  Audio context data, depends on type


##  Head-Mounted-Display device parameters

type
  VrDeviceInfo* {.bycopy.} = object
    hResolution*: cint         ##  HMD horizontal resolution in pixels
    vResolution*: cint         ##  HMD vertical resolution in pixels
    hScreenSize*: cfloat       ##  HMD horizontal size in meters
    vScreenSize*: cfloat       ##  HMD vertical size in meters
    vScreenCenter*: cfloat     ##  HMD screen center in meters
    eyeToScreenDistance*: cfloat ##  HMD distance between eye and display in meters
    lensSeparationDistance*: cfloat ##  HMD lens separation distance in meters
    interpupillaryDistance*: cfloat ##  HMD IPD (distance between pupils) in meters
    lensDistortionValues*: array[4, cfloat] ##  HMD lens distortion constant parameters
    chromaAbCorrection*: array[4, cfloat] ##  HMD chromatic aberration correction parameters


## ----------------------------------------------------------------------------------
##  Enumerators Definition
## ----------------------------------------------------------------------------------
##  System/Window config flags
##  NOTE: Every bit registers one state (use it with bit masks)
##  By default all flags are set to 0

type
  ConfigFlag* {.size: sizeof(cint), pure.} = enum
    FULLSCREEN_MODE = 0x00000002, ##  Set to run program in fullscreen
    WINDOW_RESIZABLE = 0x00000004, ##  Set to allow resizable window
    WINDOW_UNDECORATED = 0x00000008, ##  Set to disable window decoration (frame and buttons)
    WINDOW_TRANSPARENT = 0x00000010, ##  Set to allow transparent framebuffer
    MSAA_4X_HINT = 0x00000020,  ##  Set to try enabling MSAA 4X
    VSYNC_HINT = 0x00000040,    ##  Set to try enabling V-Sync on GPU
    WINDOW_HIDDEN = 0x00000080, ##  Set to hide window
    WINDOW_ALWAYS_RUN = 0x00000100, ##  Set to allow windows running while minimized
    WINDOW_MINIMIZED = 0x00000200, ##  Set to minimize window (iconify)
    WINDOW_MAXIMIZED = 0x00000400, ##  Set to maximize window (expanded to monitor)
    WINDOW_UNFOCUSED = 0x00000800, ##  Set to window non focused
    WINDOW_TOPMOST = 0x00001000, ##  Set to window always on top
    WINDOW_HIGHDPI = 0x00002000, ##  Set to support HighDPI
    INTERLACED_HINT = 0x00010000


##  Trace log type

type
  TraceLogType* {.size: sizeof(cint), pure.} = enum
    ALL = 0,                    ##  Display all logs
    TRACE, DEBUG, INFO, WARNING, ERROR, FATAL, NONE ##  Disable logging


##  Keyboard keys (US keyboard layout)
##  NOTE: Use GetKeyPressed() to allow redefining
##  required keys for alternative layouts

type                          ##  Alphanumeric keys
  KeyboardKey* {.size: sizeof(cint), pure.} = enum
    SPACE = 32, APOSTROPHE = 39, COMMA = 44, MINUS = 45, PERIOD = 46, SLASH = 47, ZERO = 48,
    ONE = 49, TWO = 50, THREE = 51, FOUR = 52, FIVE = 53, SIX = 54, SEVEN = 55, EIGHT = 56, NINE = 57,
    SEMICOLON = 59, EQUAL = 61, A = 65, B = 66, C = 67, D = 68, E = 69, F = 70, G = 71, H = 72, I = 73, J = 74,
    K = 75, L = 76, M = 77, N = 78, O = 79, P = 80, Q = 81, R = 82, S = 83, T = 84, U = 85, V = 86, W = 87, X = 88,
    Y = 89, Z = 90,                ##  Function keys
    LEFT_BRACKET = 91, BACKSLASH = 92, RIGHT_BRACKET = 93, GRAVE = 96, ##  Keypad keys
    ESCAPE = 256, ENTER = 257, TAB = 258, BACKSPACE = 259, INSERT = 260, DELETE = 261,
    RIGHT = 262, LEFT = 263, DOWN = 264, UP = 265, PAGE_UP = 266, PAGE_DOWN = 267, HOME = 268,
    END = 269, CAPS_LOCK = 280, SCROLL_LOCK = 281, NUM_LOCK = 282, PRINT_SCREEN = 283,
    PAUSE = 284, F1 = 290, F2 = 291, F3 = 292, F4 = 293, F5 = 294, F6 = 295, F7 = 296, F8 = 297, F9 = 298,
    F10 = 299, F11 = 300, F12 = 301, KP_0 = 320, KP_1 = 321, KP_2 = 322, KP_3 = 323, KP_4 = 324,
    KP_5 = 325, KP_6 = 326, KP_7 = 327, KP_8 = 328, KP_9 = 329, KP_DECIMAL = 330, KP_DIVIDE = 331,
    KP_MULTIPLY = 332, KP_SUBTRACT = 333, KP_ADD = 334, KP_ENTER = 335, KP_EQUAL = 336,
    LEFT_SHIFT = 340, LEFT_CONTROL = 341, LEFT_ALT = 342, LEFT_SUPER = 343,
    RIGHT_SHIFT = 344, RIGHT_CONTROL = 345, RIGHT_ALT = 346, RIGHT_SUPER = 347,
    KB_MENU = 348


##  Android buttons

type
  AndroidButton* {.size: sizeof(cint), pure.} = enum
    BACK = 4, VOLUME_UP = 24, VOLUME_DOWN = 25, MENU = 82


##  Mouse buttons

type
  MouseButton* {.size: sizeof(cint), pure.} = enum
    LEFT_BUTTON = 0, RIGHT_BUTTON = 1, MIDDLE_BUTTON = 2


##  Mouse cursor types

type
  MouseCursor* {.size: sizeof(cint), pure.} = enum
    CURSOR_DEFAULT = 0, CURSOR_ARROW = 1, CURSOR_IBEAM = 2, CURSOR_CROSSHAIR = 3,
    CURSOR_POINTING_HAND = 4, CURSOR_RESIZE_EW = 5, ##  The horizontal resize/move arrow shape
    CURSOR_RESIZE_NS = 6,       ##  The vertical resize/move arrow shape
    CURSOR_RESIZE_NWSE = 7,     ##  The top-left to bottom-right diagonal resize/move arrow shape
    CURSOR_RESIZE_NESW = 8,     ##  The top-right to bottom-left diagonal resize/move arrow shape
    CURSOR_RESIZE_ALL = 9,      ##  The omni-directional resize/move cursor shape
    CURSOR_NOT_ALLOWED = 10


##  Gamepad number

type
  GamepadNumber* {.size: sizeof(cint), pure.} = enum
    PLAYER1 = 0, PLAYER2 = 1, PLAYER3 = 2, PLAYER4 = 3


##  Gamepad buttons

type                          ##  This is here just for error checking
  GamepadButton* {.size: sizeof(cint), pure.} = enum
    BUTTON_UNKNOWN = 0,         ##  This is normally a DPAD
    BUTTON_LEFT_FACE_UP, BUTTON_LEFT_FACE_RIGHT, BUTTON_LEFT_FACE_DOWN, BUTTON_LEFT_FACE_LEFT, ##  This normally corresponds with PlayStation and Xbox controllers
                                                                                           ##  XBOX: [Y,X,A,B]
                                                                                           ##  PS3: [Triangle,Square,Cross,Circle]
                                                                                           ##  No support for 6 button controllers though..
    BUTTON_RIGHT_FACE_UP, BUTTON_RIGHT_FACE_RIGHT, BUTTON_RIGHT_FACE_DOWN, BUTTON_RIGHT_FACE_LEFT, ##  Triggers
    BUTTON_LEFT_TRIGGER_1, BUTTON_LEFT_TRIGGER_2, BUTTON_RIGHT_TRIGGER_1, BUTTON_RIGHT_TRIGGER_2, ##  These are buttons in the center of the gamepad
    BUTTON_MIDDLE_LEFT,       ## PS3 Select
    BUTTON_MIDDLE,            ## PS Button/XBOX Button
    BUTTON_MIDDLE_RIGHT,      ## PS3 Start
                        ##  These are the joystick press in buttons
    BUTTON_LEFT_THUMB, BUTTON_RIGHT_THUMB


##  Gamepad axis

type                          ##  Left stick
  GamepadAxis* {.size: sizeof(cint), pure.} = enum
    AXIS_LEFT_X = 0, AXIS_LEFT_Y = 1, ##  Right stick
    AXIS_RIGHT_X = 2, AXIS_RIGHT_Y = 3, ##  Pressure levels for the back triggers
    AXIS_LEFT_TRIGGER = 4,      ##  [1..-1] (pressure-level)
    AXIS_RIGHT_TRIGGER = 5


##  Shader location points

type
  ShaderLocationIndex* {.size: sizeof(cint), pure.} = enum
    VERTEX_POSITION = 0, VERTEX_TEXCOORD01, VERTEX_TEXCOORD02, VERTEX_NORMAL,
    VERTEX_TANGENT, VERTEX_COLOR, MATRIX_MVP, MATRIX_MODEL, MATRIX_VIEW,
    MATRIX_PROJECTION, VECTOR_VIEW, COLOR_DIFFUSE, COLOR_SPECULAR, COLOR_AMBIENT, MAP_ALBEDO, ##  LOC_MAP_DIFFUSE
    MAP_METALNESS,            ##  LOC_MAP_SPECULAR
    MAP_NORMAL, MAP_ROUGHNESS, MAP_OCCLUSION, MAP_EMISSION, MAP_HEIGHT, MAP_CUBEMAP,
    MAP_IRRADIANCE, MAP_PREFILTER, MAP_BRDF


##  Shader uniform data types

type
  ShaderUniformDataType* {.size: sizeof(cint), pure.} = enum
    FLOAT = 0, VEC2, VEC3, VEC4, INT, IVEC2, IVEC3, IVEC4, SAMPLER2D


##  Material maps

type
  MaterialMapType* {.size: sizeof(cint), pure.} = enum
    ALBEDO = 0,                 ##  MAP_DIFFUSE
    METALNESS = 1,              ##  MAP_SPECULAR
    NORMAL = 2, ROUGHNESS = 3, OCCLUSION, EMISSION, HEIGHT, CUBEMAP, ##  NOTE: Uses GL_TEXTURE_CUBE_MAP
    IRRADIANCE,               ##  NOTE: Uses GL_TEXTURE_CUBE_MAP
    PREFILTER,                ##  NOTE: Uses GL_TEXTURE_CUBE_MAP
    BRDF


##  Pixel formats
##  NOTE: Support depends on OpenGL version and platform

type
  PixelFormat* {.size: sizeof(cint), pure.} = enum
    UNCOMPRESSED_GRAYSCALE = 1, ##  8 bit per pixel (no alpha)
    UNCOMPRESSED_GRAY_ALPHA,  ##  8*2 bpp (2 channels)
    UNCOMPRESSED_R5G6B5,      ##  16 bpp
    UNCOMPRESSED_R8G8B8,      ##  24 bpp
    UNCOMPRESSED_R5G5B5A1,    ##  16 bpp (1 bit alpha)
    UNCOMPRESSED_R4G4B4A4,    ##  16 bpp (4 bit alpha)
    UNCOMPRESSED_R8G8B8A8,    ##  32 bpp
    UNCOMPRESSED_R32,         ##  32 bpp (1 channel - float)
    UNCOMPRESSED_R32G32B32,   ##  32*3 bpp (3 channels - float)
    UNCOMPRESSED_R32G32B32A32, ##  32*4 bpp (4 channels - float)
    COMPRESSED_DXT1_RGB,      ##  4 bpp (no alpha)
    COMPRESSED_DXT1_RGBA,     ##  4 bpp (1 bit alpha)
    COMPRESSED_DXT3_RGBA,     ##  8 bpp
    COMPRESSED_DXT5_RGBA,     ##  8 bpp
    COMPRESSED_ETC1_RGB,      ##  4 bpp
    COMPRESSED_ETC2_RGB,      ##  4 bpp
    COMPRESSED_ETC2_EAC_RGBA, ##  8 bpp
    COMPRESSED_PVRT_RGB,      ##  4 bpp
    COMPRESSED_PVRT_RGBA,     ##  4 bpp
    COMPRESSED_ASTC_4x4RGBA,  ##  8 bpp
    COMPRESSED_ASTC_8x8RGBA   ##  2 bpp


##  Texture parameters: filter mode
##  NOTE 1: Filtering considers mipmaps if available in the texture
##  NOTE 2: Filter is accordingly set for minification and magnification

type
  TextureFilterMode* {.size: sizeof(cint), pure.} = enum
    POINT = 0,                  ##  No filter, just pixel aproximation
    BILINEAR,                 ##  Linear filtering
    TRILINEAR,                ##  Trilinear filtering (linear with mipmaps)
    ANISOTROPIC_4X,           ##  Anisotropic filtering 4x
    ANISOTROPIC_8X,           ##  Anisotropic filtering 8x
    ANISOTROPIC_16X           ##  Anisotropic filtering 16x


##  Texture parameters: wrap mode

type
  TextureWrapMode* {.size: sizeof(cint), pure.} = enum
    REPEAT = 0,                 ##  Repeats texture in tiled mode
    CLAMP,                    ##  Clamps texture to edge pixel in tiled mode
    MIRROR_REPEAT,            ##  Mirrors and repeats the texture in tiled mode
    MIRROR_CLAMP              ##  Mirrors and clamps to border the texture in tiled mode


##  Cubemap layouts

type
  CubemapLayoutType* {.size: sizeof(cint), pure.} = enum
    AUTO_DETECT = 0,            ##  Automatically detect layout type
    LINE_VERTICAL,            ##  Layout is defined by a vertical line with faces
    LINE_HORIZONTAL,          ##  Layout is defined by an horizontal line with faces
    CROSS_THREE_BY_FOUR,      ##  Layout is defined by a 3x4 cross with cubemap faces
    CROSS_FOUR_BY_THREE,      ##  Layout is defined by a 4x3 cross with cubemap faces
    PANORAMA                  ##  Layout is defined by a panorama image (equirectangular map)


##  Font type, defines generation method

type
  FontType* {.size: sizeof(cint), pure.} = enum
    DEFAULT = 0,                ##  Default font generation, anti-aliased
    BITMAP,                   ##  Bitmap font generation, no anti-aliasing
    SDF                       ##  SDF font generation, requires external shader


##  Color blending modes (pre-defined)

type
  BlendMode* {.size: sizeof(cint), pure.} = enum
    ALPHA = 0,                  ##  Blend textures considering alpha (default)
    ADDITIVE,                 ##  Blend textures adding colors
    MULTIPLIED,               ##  Blend textures multiplying colors
    ADD_COLORS,               ##  Blend textures adding colors (alternative)
    SUBTRACT_COLORS,          ##  Blend textures subtracting colors (alternative)
    CUSTOM                    ##  Belnd textures using custom src/dst factors (use SetBlendModeCustom())


##  Gestures type
##  NOTE: It could be used as flags to enable only some gestures

type
  GestureType* {.size: sizeof(cint), pure.} = enum
    NONE = 0, TAP = 1, DOUBLETAP = 2, HOLD = 4, DRAG = 8, SWIPE_RIGHT = 16, SWIPE_LEFT = 32,
    SWIPE_UP = 64, SWIPE_DOWN = 128, PINCH_IN = 256, PINCH_OUT = 512


##  Camera system modes

type
  CameraMode* {.size: sizeof(cint), pure.} = enum
    CUSTOM = 0, FREE, ORBITAL, FIRST_PERSON, THIRD_PERSON


##  Camera projection modes

type
  CameraType* {.size: sizeof(cint), pure.} = enum
    PERSPECTIVE = 0, ORTHOGRAPHIC


##  N-patch types

type
  NPatchType* {.size: sizeof(cint), pure.} = enum
    NPT_9PATCH = 0,             ##  Npatch defined by 3x3 tiles
    NPT_3PATCH_VERTICAL,      ##  Npatch defined by 1x3 tiles
    NPT_3PATCH_HORIZONTAL     ##  Npatch defined by 3x1 tiles


##  Callbacks to be implemented by users

type
  TraceLogCallback* = proc (logType: cint; text: cstring; args: va_list) {.cdecl.}

## ------------------------------------------------------------------------------------
##  Global Variables Definition
## ------------------------------------------------------------------------------------
##  It's lonely here...
## ------------------------------------------------------------------------------------
##  Window and Graphics Device Functions (Module: core)
## ------------------------------------------------------------------------------------
##  Window-related functions

proc initWindow*(width: cint; height: cint; title: cstring) {.cdecl,
    importc: "InitWindow", dynlib: raylibdll.}
##  Initialize window and OpenGL context

proc windowShouldClose*(): bool {.cdecl, importc: "WindowShouldClose",
                               dynlib: raylibdll.}
##  Check if KEY_ESCAPE pressed or Close icon pressed

proc closeWindow*() {.cdecl, importc: "CloseWindow", dynlib: raylibdll.}
##  Close window and unload OpenGL context

proc isWindowReady*(): bool {.cdecl, importc: "IsWindowReady", dynlib: raylibdll.}
##  Check if window has been initialized successfully

proc isWindowFullscreen*(): bool {.cdecl, importc: "IsWindowFullscreen",
                                dynlib: raylibdll.}
##  Check if window is currently fullscreen

proc isWindowHidden*(): bool {.cdecl, importc: "IsWindowHidden", dynlib: raylibdll.}
##  Check if window is currently hidden (only PLATFORM_DESKTOP)

proc isWindowMinimized*(): bool {.cdecl, importc: "IsWindowMinimized",
                               dynlib: raylibdll.}
##  Check if window is currently minimized (only PLATFORM_DESKTOP)

proc isWindowMaximized*(): bool {.cdecl, importc: "IsWindowMaximized",
                               dynlib: raylibdll.}
##  Check if window is currently maximized (only PLATFORM_DESKTOP)

proc isWindowFocused*(): bool {.cdecl, importc: "IsWindowFocused", dynlib: raylibdll.}
##  Check if window is currently focused (only PLATFORM_DESKTOP)

proc isWindowResized*(): bool {.cdecl, importc: "IsWindowResized", dynlib: raylibdll.}
##  Check if window has been resized last frame

proc isWindowState*(flag: cuint): bool {.cdecl, importc: "IsWindowState",
                                     dynlib: raylibdll.}
##  Check if one specific window flag is enabled

proc setWindowState*(flags: cuint) {.cdecl, importc: "SetWindowState",
                                  dynlib: raylibdll.}
##  Set window configuration state using flags

proc clearWindowState*(flags: cuint) {.cdecl, importc: "ClearWindowState",
                                    dynlib: raylibdll.}
##  Clear window configuration state flags

proc toggleFullscreen*() {.cdecl, importc: "ToggleFullscreen", dynlib: raylibdll.}
##  Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)

proc maximizeWindow*() {.cdecl, importc: "MaximizeWindow", dynlib: raylibdll.}
##  Set window state: maximized, if resizable (only PLATFORM_DESKTOP)

proc minimizeWindow*() {.cdecl, importc: "MinimizeWindow", dynlib: raylibdll.}
##  Set window state: minimized, if resizable (only PLATFORM_DESKTOP)

proc restoreWindow*() {.cdecl, importc: "RestoreWindow", dynlib: raylibdll.}
##  Set window state: not minimized/maximized (only PLATFORM_DESKTOP)

proc setWindowIcon*(image: Image) {.cdecl, importc: "SetWindowIcon", dynlib: raylibdll.}
##  Set icon for window (only PLATFORM_DESKTOP)

proc setWindowTitle*(title: cstring) {.cdecl, importc: "SetWindowTitle",
                                    dynlib: raylibdll.}
##  Set title for window (only PLATFORM_DESKTOP)

proc setWindowPosition*(x: cint; y: cint) {.cdecl, importc: "SetWindowPosition",
                                       dynlib: raylibdll.}
##  Set window position on screen (only PLATFORM_DESKTOP)

proc setWindowMonitor*(monitor: cint) {.cdecl, importc: "SetWindowMonitor",
                                     dynlib: raylibdll.}
##  Set monitor for the current window (fullscreen mode)

proc setWindowMinSize*(width: cint; height: cint) {.cdecl,
    importc: "SetWindowMinSize", dynlib: raylibdll.}
##  Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)

proc setWindowSize*(width: cint; height: cint) {.cdecl, importc: "SetWindowSize",
    dynlib: raylibdll.}
##  Set window dimensions

proc getWindowHandle*(): pointer {.cdecl, importc: "GetWindowHandle",
                                dynlib: raylibdll.}
##  Get native window handle

proc getScreenWidth*(): cint {.cdecl, importc: "GetScreenWidth", dynlib: raylibdll.}
##  Get current screen width

proc getScreenHeight*(): cint {.cdecl, importc: "GetScreenHeight", dynlib: raylibdll.}
##  Get current screen height

proc getMonitorCount*(): cint {.cdecl, importc: "GetMonitorCount", dynlib: raylibdll.}
##  Get number of connected monitors

proc getCurrentMonitor*(): cint {.cdecl, importc: "GetCurrentMonitor",
                               dynlib: raylibdll.}
##  Get current connected monitor

proc getMonitorPosition*(monitor: cint): Vector2 {.cdecl,
    importc: "GetMonitorPosition", dynlib: raylibdll.}
##  Get specified monitor position

proc getMonitorWidth*(monitor: cint): cint {.cdecl, importc: "GetMonitorWidth",
    dynlib: raylibdll.}
##  Get specified monitor width

proc getMonitorHeight*(monitor: cint): cint {.cdecl, importc: "GetMonitorHeight",
    dynlib: raylibdll.}
##  Get specified monitor height

proc getMonitorPhysicalWidth*(monitor: cint): cint {.cdecl,
    importc: "GetMonitorPhysicalWidth", dynlib: raylibdll.}
##  Get specified monitor physical width in millimetres

proc getMonitorPhysicalHeight*(monitor: cint): cint {.cdecl,
    importc: "GetMonitorPhysicalHeight", dynlib: raylibdll.}
##  Get specified monitor physical height in millimetres

proc getMonitorRefreshRate*(monitor: cint): cint {.cdecl,
    importc: "GetMonitorRefreshRate", dynlib: raylibdll.}
##  Get specified monitor refresh rate

proc getWindowPosition*(): Vector2 {.cdecl, importc: "GetWindowPosition",
                                  dynlib: raylibdll.}
##  Get window position XY on monitor

proc getWindowScaleDPI*(): Vector2 {.cdecl, importc: "GetWindowScaleDPI",
                                  dynlib: raylibdll.}
##  Get window scale DPI factor

proc getMonitorName*(monitor: cint): cstring {.cdecl, importc: "GetMonitorName",
    dynlib: raylibdll.}
##  Get the human-readable, UTF-8 encoded name of the primary monitor

proc setClipboardText*(text: cstring) {.cdecl, importc: "SetClipboardText",
                                     dynlib: raylibdll.}
##  Set clipboard text content

proc getClipboardText*(): cstring {.cdecl, importc: "GetClipboardText",
                                 dynlib: raylibdll.}
##  Get clipboard text content
##  Cursor-related functions

proc showCursor*() {.cdecl, importc: "ShowCursor", dynlib: raylibdll.}
##  Shows cursor

proc hideCursor*() {.cdecl, importc: "HideCursor", dynlib: raylibdll.}
##  Hides cursor

proc isCursorHidden*(): bool {.cdecl, importc: "IsCursorHidden", dynlib: raylibdll.}
##  Check if cursor is not visible

proc enableCursor*() {.cdecl, importc: "EnableCursor", dynlib: raylibdll.}
##  Enables cursor (unlock cursor)

proc disableCursor*() {.cdecl, importc: "DisableCursor", dynlib: raylibdll.}
##  Disables cursor (lock cursor)

proc isCursorOnScreen*(): bool {.cdecl, importc: "IsCursorOnScreen", dynlib: raylibdll.}
##  Check if cursor is on the current screen.
##  Drawing-related functions

proc clearBackground*(color: Color) {.cdecl, importc: "ClearBackground",
                                   dynlib: raylibdll.}
##  Set background color (framebuffer clear color)

proc beginDrawing*() {.cdecl, importc: "BeginDrawing", dynlib: raylibdll.}
##  Setup canvas (framebuffer) to start drawing

proc endDrawing*() {.cdecl, importc: "EndDrawing", dynlib: raylibdll.}
##  End canvas drawing and swap buffers (double buffering)

proc beginMode2D*(camera: Camera2D) {.cdecl, importc: "BeginMode2D", dynlib: raylibdll.}
##  Initialize 2D mode with custom camera (2D)

proc endMode2D*() {.cdecl, importc: "EndMode2D", dynlib: raylibdll.}
##  Ends 2D mode with custom camera

proc beginMode3D*(camera: Camera3D) {.cdecl, importc: "BeginMode3D", dynlib: raylibdll.}
##  Initializes 3D mode with custom camera (3D)

proc endMode3D*() {.cdecl, importc: "EndMode3D", dynlib: raylibdll.}
##  Ends 3D mode and returns to default 2D orthographic mode

proc beginTextureMode*(target: RenderTexture2D) {.cdecl,
    importc: "BeginTextureMode", dynlib: raylibdll.}
##  Initializes render texture for drawing

proc endTextureMode*() {.cdecl, importc: "EndTextureMode", dynlib: raylibdll.}
##  Ends drawing to render texture

proc beginScissorMode*(x: cint; y: cint; width: cint; height: cint) {.cdecl,
    importc: "BeginScissorMode", dynlib: raylibdll.}
##  Begin scissor mode (define screen area for following drawing)

proc endScissorMode*() {.cdecl, importc: "EndScissorMode", dynlib: raylibdll.}
##  End scissor mode
##  Screen-space-related functions

proc getMouseRay*(mousePosition: Vector2; camera: Camera): Ray {.cdecl,
    importc: "GetMouseRay", dynlib: raylibdll.}
##  Returns a ray trace from mouse position

proc getCameraMatrix*(camera: Camera): Matrix {.cdecl, importc: "GetCameraMatrix",
    dynlib: raylibdll.}
##  Returns camera transform matrix (view matrix)

proc getCameraMatrix2D*(camera: Camera2D): Matrix {.cdecl,
    importc: "GetCameraMatrix2D", dynlib: raylibdll.}
##  Returns camera 2d transform matrix

proc getWorldToScreen*(position: Vector3; camera: Camera): Vector2 {.cdecl,
    importc: "GetWorldToScreen", dynlib: raylibdll.}
##  Returns the screen space position for a 3d world space position

proc getWorldToScreenEx*(position: Vector3; camera: Camera; width: cint; height: cint): Vector2 {.
    cdecl, importc: "GetWorldToScreenEx", dynlib: raylibdll.}
##  Returns size position for a 3d world space position

proc getWorldToScreen2D*(position: Vector2; camera: Camera2D): Vector2 {.cdecl,
    importc: "GetWorldToScreen2D", dynlib: raylibdll.}
##  Returns the screen space position for a 2d camera world space position

proc getScreenToWorld2D*(position: Vector2; camera: Camera2D): Vector2 {.cdecl,
    importc: "GetScreenToWorld2D", dynlib: raylibdll.}
##  Returns the world space position for a 2d camera screen space position
##  Timing-related functions

proc setTargetFPS*(fps: cint) {.cdecl, importc: "SetTargetFPS", dynlib: raylibdll.}
##  Set target FPS (maximum)

proc getFPS*(): cint {.cdecl, importc: "GetFPS", dynlib: raylibdll.}
##  Returns current FPS

proc getFrameTime*(): cfloat {.cdecl, importc: "GetFrameTime", dynlib: raylibdll.}
##  Returns time in seconds for last frame drawn

proc getTime*(): cdouble {.cdecl, importc: "GetTime", dynlib: raylibdll.}
##  Returns elapsed time in seconds since InitWindow()
##  Misc. functions

proc setConfigFlags*(flags: cuint) {.cdecl, importc: "SetConfigFlags",
                                  dynlib: raylibdll.}
##  Setup init configuration flags (view FLAGS)

proc setTraceLogLevel*(logType: cint) {.cdecl, importc: "SetTraceLogLevel",
                                     dynlib: raylibdll.}
##  Set the current threshold (minimum) log level

proc setTraceLogExit*(logType: cint) {.cdecl, importc: "SetTraceLogExit",
                                    dynlib: raylibdll.}
##  Set the exit threshold (minimum) log level

proc setTraceLogCallback*(callback: TraceLogCallback) {.cdecl,
    importc: "SetTraceLogCallback", dynlib: raylibdll.}
##  Set a trace log callback to enable custom logging

proc traceLog*(logType: cint; text: cstring) {.varargs, cdecl, importc: "TraceLog",
    dynlib: raylibdll.}
##  Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR)

proc memAlloc*(size: cint): pointer {.cdecl, importc: "MemAlloc", dynlib: raylibdll.}
##  Internal memory allocator

proc memFree*(`ptr`: pointer) {.cdecl, importc: "MemFree", dynlib: raylibdll.}
##  Internal memory free

proc takeScreenshot*(fileName: cstring) {.cdecl, importc: "TakeScreenshot",
                                       dynlib: raylibdll.}
##  Takes a screenshot of current screen (saved a .png)

proc getRandomValue*(min: cint; max: cint): cint {.cdecl, importc: "GetRandomValue",
    dynlib: raylibdll.}
##  Returns a random value between min and max (both included)
##  Files management functions

proc loadFileData*(fileName: cstring; bytesRead: ptr cuint): ptr uint8 {.cdecl,
    importc: "LoadFileData", dynlib: raylibdll.}
##  Load file data as byte array (read)

proc unloadFileData*(data: ptr uint8) {.cdecl, importc: "UnloadFileData",
                                     dynlib: raylibdll.}
##  Unload file data allocated by LoadFileData()

proc saveFileData*(fileName: cstring; data: pointer; bytesToWrite: cuint): bool {.cdecl,
    importc: "SaveFileData", dynlib: raylibdll.}
##  Save data to file from byte array (write), returns true on success

proc loadFileText*(fileName: cstring): cstring {.cdecl, importc: "LoadFileText",
    dynlib: raylibdll.}
##  Load text data from file (read), returns a '\0' terminated string

proc unloadFileText*(text: ptr uint8) {.cdecl, importc: "UnloadFileText",
                                     dynlib: raylibdll.}
##  Unload file text data allocated by LoadFileText()

proc saveFileText*(fileName: cstring; text: cstring): bool {.cdecl,
    importc: "SaveFileText", dynlib: raylibdll.}
##  Save text data to file (write), string must be '\0' terminated, returns true on success

proc fileExists*(fileName: cstring): bool {.cdecl, importc: "FileExists",
                                        dynlib: raylibdll.}
##  Check if file exists

proc directoryExists*(dirPath: cstring): bool {.cdecl, importc: "DirectoryExists",
    dynlib: raylibdll.}
##  Check if a directory path exists

proc isFileExtension*(fileName: cstring; ext: cstring): bool {.cdecl,
    importc: "IsFileExtension", dynlib: raylibdll.}
##  Check file extension (including point: .png, .wav)

proc getFileExtension*(fileName: cstring): cstring {.cdecl,
    importc: "GetFileExtension", dynlib: raylibdll.}
##  Get pointer to extension for a filename string (including point: ".png")

proc getFileName*(filePath: cstring): cstring {.cdecl, importc: "GetFileName",
    dynlib: raylibdll.}
##  Get pointer to filename for a path string

proc getFileNameWithoutExt*(filePath: cstring): cstring {.cdecl,
    importc: "GetFileNameWithoutExt", dynlib: raylibdll.}
##  Get filename string without extension (uses static string)

proc getDirectoryPath*(filePath: cstring): cstring {.cdecl,
    importc: "GetDirectoryPath", dynlib: raylibdll.}
##  Get full path for a given fileName with path (uses static string)

proc getPrevDirectoryPath*(dirPath: cstring): cstring {.cdecl,
    importc: "GetPrevDirectoryPath", dynlib: raylibdll.}
##  Get previous directory path for a given path (uses static string)

proc getWorkingDirectory*(): cstring {.cdecl, importc: "GetWorkingDirectory",
                                    dynlib: raylibdll.}
##  Get current working directory (uses static string)

proc getDirectoryFiles*(dirPath: cstring; count: ptr cint): cstringArray {.cdecl,
    importc: "GetDirectoryFiles", dynlib: raylibdll.}
##  Get filenames in a directory path (memory should be freed)

proc clearDirectoryFiles*() {.cdecl, importc: "ClearDirectoryFiles",
                            dynlib: raylibdll.}
##  Clear directory files paths buffers (free memory)

proc changeDirectory*(dir: cstring): bool {.cdecl, importc: "ChangeDirectory",
                                        dynlib: raylibdll.}
##  Change working directory, return true on success

proc isFileDropped*(): bool {.cdecl, importc: "IsFileDropped", dynlib: raylibdll.}
##  Check if a file has been dropped into window

proc getDroppedFiles*(count: ptr cint): cstringArray {.cdecl,
    importc: "GetDroppedFiles", dynlib: raylibdll.}
##  Get dropped files names (memory should be freed)

proc clearDroppedFiles*() {.cdecl, importc: "ClearDroppedFiles", dynlib: raylibdll.}
##  Clear dropped files paths buffer (free memory)

proc getFileModTime*(fileName: cstring): clong {.cdecl, importc: "GetFileModTime",
    dynlib: raylibdll.}
##  Get file modification time (last write time)

proc compressData*(data: ptr uint8; dataLength: cint; compDataLength: ptr cint): ptr uint8 {.
    cdecl, importc: "CompressData", dynlib: raylibdll.}
##  Compress data (DEFLATE algorithm)

proc decompressData*(compData: ptr uint8; compDataLength: cint; dataLength: ptr cint): ptr uint8 {.
    cdecl, importc: "DecompressData", dynlib: raylibdll.}
##  Decompress data (DEFLATE algorithm)
##  Persistent storage management

proc saveStorageValue*(position: cuint; value: cint): bool {.cdecl,
    importc: "SaveStorageValue", dynlib: raylibdll.}
##  Save integer value to storage file (to defined position), returns true on success

proc loadStorageValue*(position: cuint): cint {.cdecl, importc: "LoadStorageValue",
    dynlib: raylibdll.}
##  Load integer value from storage file (from defined position)

proc openURL*(url: cstring) {.cdecl, importc: "OpenURL", dynlib: raylibdll.}
##  Open URL with default system browser (if available)
## ------------------------------------------------------------------------------------
##  Input Handling Functions (Module: core)
## ------------------------------------------------------------------------------------
##  Input-related functions: keyboard

proc isKeyPressed*(key: cint): bool {.cdecl, importc: "IsKeyPressed", dynlib: raylibdll.}
##  Detect if a key has been pressed once

proc isKeyDown*(key: cint): bool {.cdecl, importc: "IsKeyDown", dynlib: raylibdll.}
##  Detect if a key is being pressed

proc isKeyReleased*(key: cint): bool {.cdecl, importc: "IsKeyReleased",
                                   dynlib: raylibdll.}
##  Detect if a key has been released once

proc isKeyUp*(key: cint): bool {.cdecl, importc: "IsKeyUp", dynlib: raylibdll.}
##  Detect if a key is NOT being pressed

proc setExitKey*(key: cint) {.cdecl, importc: "SetExitKey", dynlib: raylibdll.}
##  Set a custom key to exit program (default is ESC)

proc getKeyPressed*(): cint {.cdecl, importc: "GetKeyPressed", dynlib: raylibdll.}
##  Get key pressed (keycode), call it multiple times for keys queued

proc getCharPressed*(): cint {.cdecl, importc: "GetCharPressed", dynlib: raylibdll.}
##  Get char pressed (unicode), call it multiple times for chars queued
##  Input-related functions: gamepads

proc isGamepadAvailable*(gamepad: cint): bool {.cdecl, importc: "IsGamepadAvailable",
    dynlib: raylibdll.}
##  Detect if a gamepad is available

proc isGamepadName*(gamepad: cint; name: cstring): bool {.cdecl,
    importc: "IsGamepadName", dynlib: raylibdll.}
##  Check gamepad name (if available)

proc getGamepadName*(gamepad: cint): cstring {.cdecl, importc: "GetGamepadName",
    dynlib: raylibdll.}
##  Return gamepad internal name id

proc isGamepadButtonPressed*(gamepad: cint; button: cint): bool {.cdecl,
    importc: "IsGamepadButtonPressed", dynlib: raylibdll.}
##  Detect if a gamepad button has been pressed once

proc isGamepadButtonDown*(gamepad: cint; button: cint): bool {.cdecl,
    importc: "IsGamepadButtonDown", dynlib: raylibdll.}
##  Detect if a gamepad button is being pressed

proc isGamepadButtonReleased*(gamepad: cint; button: cint): bool {.cdecl,
    importc: "IsGamepadButtonReleased", dynlib: raylibdll.}
##  Detect if a gamepad button has been released once

proc isGamepadButtonUp*(gamepad: cint; button: cint): bool {.cdecl,
    importc: "IsGamepadButtonUp", dynlib: raylibdll.}
##  Detect if a gamepad button is NOT being pressed

proc getGamepadButtonPressed*(): cint {.cdecl, importc: "GetGamepadButtonPressed",
                                     dynlib: raylibdll.}
##  Get the last gamepad button pressed

proc getGamepadAxisCount*(gamepad: cint): cint {.cdecl,
    importc: "GetGamepadAxisCount", dynlib: raylibdll.}
##  Return gamepad axis count for a gamepad

proc getGamepadAxisMovement*(gamepad: cint; axis: cint): cfloat {.cdecl,
    importc: "GetGamepadAxisMovement", dynlib: raylibdll.}
##  Return axis movement value for a gamepad axis
##  Input-related functions: mouse

proc isMouseButtonPressed*(button: cint): bool {.cdecl,
    importc: "IsMouseButtonPressed", dynlib: raylibdll.}
##  Detect if a mouse button has been pressed once

proc isMouseButtonDown*(button: cint): bool {.cdecl, importc: "IsMouseButtonDown",
    dynlib: raylibdll.}
##  Detect if a mouse button is being pressed

proc isMouseButtonReleased*(button: cint): bool {.cdecl,
    importc: "IsMouseButtonReleased", dynlib: raylibdll.}
##  Detect if a mouse button has been released once

proc isMouseButtonUp*(button: cint): bool {.cdecl, importc: "IsMouseButtonUp",
                                        dynlib: raylibdll.}
##  Detect if a mouse button is NOT being pressed

proc getMouseX*(): cint {.cdecl, importc: "GetMouseX", dynlib: raylibdll.}
##  Returns mouse position X

proc getMouseY*(): cint {.cdecl, importc: "GetMouseY", dynlib: raylibdll.}
##  Returns mouse position Y

proc getMousePosition*(): Vector2 {.cdecl, importc: "GetMousePosition",
                                 dynlib: raylibdll.}
##  Returns mouse position XY

proc setMousePosition*(x: cint; y: cint) {.cdecl, importc: "SetMousePosition",
                                      dynlib: raylibdll.}
##  Set mouse position XY

proc setMouseOffset*(offsetX: cint; offsetY: cint) {.cdecl, importc: "SetMouseOffset",
    dynlib: raylibdll.}
##  Set mouse offset

proc setMouseScale*(scaleX: cfloat; scaleY: cfloat) {.cdecl, importc: "SetMouseScale",
    dynlib: raylibdll.}
##  Set mouse scaling

proc getMouseWheelMove*(): cfloat {.cdecl, importc: "GetMouseWheelMove",
                                 dynlib: raylibdll.}
##  Returns mouse wheel movement Y

proc getMouseCursor*(): cint {.cdecl, importc: "GetMouseCursor", dynlib: raylibdll.}
##  Returns mouse cursor if (MouseCursor enum)

proc setMouseCursor*(cursor: cint) {.cdecl, importc: "SetMouseCursor",
                                  dynlib: raylibdll.}
##  Set mouse cursor
##  Input-related functions: touch

proc getTouchX*(): cint {.cdecl, importc: "GetTouchX", dynlib: raylibdll.}
##  Returns touch position X for touch point 0 (relative to screen size)

proc getTouchY*(): cint {.cdecl, importc: "GetTouchY", dynlib: raylibdll.}
##  Returns touch position Y for touch point 0 (relative to screen size)

proc getTouchPosition*(index: cint): Vector2 {.cdecl, importc: "GetTouchPosition",
    dynlib: raylibdll.}
##  Returns touch position XY for a touch point index (relative to screen size)
## ------------------------------------------------------------------------------------
##  Gestures and Touch Handling Functions (Module: gestures)
## ------------------------------------------------------------------------------------

proc setGesturesEnabled*(gestureFlags: cuint) {.cdecl,
    importc: "SetGesturesEnabled", dynlib: raylibdll.}
##  Enable a set of gestures using flags

proc isGestureDetected*(gesture: cint): bool {.cdecl, importc: "IsGestureDetected",
    dynlib: raylibdll.}
##  Check if a gesture have been detected

proc getGestureDetected*(): cint {.cdecl, importc: "GetGestureDetected",
                                dynlib: raylibdll.}
##  Get latest detected gesture

proc getTouchPointsCount*(): cint {.cdecl, importc: "GetTouchPointsCount",
                                 dynlib: raylibdll.}
##  Get touch points count

proc getGestureHoldDuration*(): cfloat {.cdecl, importc: "GetGestureHoldDuration",
                                      dynlib: raylibdll.}
##  Get gesture hold time in milliseconds

proc getGestureDragVector*(): Vector2 {.cdecl, importc: "GetGestureDragVector",
                                     dynlib: raylibdll.}
##  Get gesture drag vector

proc getGestureDragAngle*(): cfloat {.cdecl, importc: "GetGestureDragAngle",
                                   dynlib: raylibdll.}
##  Get gesture drag angle

proc getGesturePinchVector*(): Vector2 {.cdecl, importc: "GetGesturePinchVector",
                                      dynlib: raylibdll.}
##  Get gesture pinch delta

proc getGesturePinchAngle*(): cfloat {.cdecl, importc: "GetGesturePinchAngle",
                                    dynlib: raylibdll.}
##  Get gesture pinch angle
## ------------------------------------------------------------------------------------
##  Camera System Functions (Module: camera)
## ------------------------------------------------------------------------------------

proc setCameraMode*(camera: Camera; mode: cint) {.cdecl, importc: "SetCameraMode",
    dynlib: raylibdll.}
##  Set camera mode (multiple camera modes available)

proc updateCamera*(camera: ptr Camera) {.cdecl, importc: "UpdateCamera",
                                     dynlib: raylibdll.}
##  Update camera position for selected mode

proc setCameraPanControl*(keyPan: cint) {.cdecl, importc: "SetCameraPanControl",
                                       dynlib: raylibdll.}
##  Set camera pan key to combine with mouse movement (free camera)

proc setCameraAltControl*(keyAlt: cint) {.cdecl, importc: "SetCameraAltControl",
                                       dynlib: raylibdll.}
##  Set camera alt key to combine with mouse movement (free camera)

proc setCameraSmoothZoomControl*(keySmoothZoom: cint) {.cdecl,
    importc: "SetCameraSmoothZoomControl", dynlib: raylibdll.}
##  Set camera smooth zoom key to combine with mouse (free camera)

proc setCameraMoveControls*(keyFront: cint; keyBack: cint; keyRight: cint;
                           keyLeft: cint; keyUp: cint; keyDown: cint) {.cdecl,
    importc: "SetCameraMoveControls", dynlib: raylibdll.}
##  Set camera move controls (1st person and 3rd person cameras)
## ------------------------------------------------------------------------------------
##  Basic Shapes Drawing Functions (Module: shapes)
## ------------------------------------------------------------------------------------
##  Basic shapes drawing functions

proc drawPixel*(posX: cint; posY: cint; color: Color) {.cdecl, importc: "DrawPixel",
    dynlib: raylibdll.}
##  Draw a pixel

proc drawPixelV*(position: Vector2; color: Color) {.cdecl, importc: "DrawPixelV",
    dynlib: raylibdll.}
##  Draw a pixel (Vector version)

proc drawLine*(startPosX: cint; startPosY: cint; endPosX: cint; endPosY: cint;
              color: Color) {.cdecl, importc: "DrawLine", dynlib: raylibdll.}
##  Draw a line

proc drawLineV*(startPos: Vector2; endPos: Vector2; color: Color) {.cdecl,
    importc: "DrawLineV", dynlib: raylibdll.}
##  Draw a line (Vector version)

proc drawLineEx*(startPos: Vector2; endPos: Vector2; thick: cfloat; color: Color) {.
    cdecl, importc: "DrawLineEx", dynlib: raylibdll.}
##  Draw a line defining thickness

proc drawLineBezier*(startPos: Vector2; endPos: Vector2; thick: cfloat; color: Color) {.
    cdecl, importc: "DrawLineBezier", dynlib: raylibdll.}
##  Draw a line using cubic-bezier curves in-out

proc drawLineBezierQuad*(startPos: Vector2; endPos: Vector2; controlPos: Vector2;
                        thick: cfloat; color: Color) {.cdecl,
    importc: "DrawLineBezierQuad", dynlib: raylibdll.}
## Draw line using quadratic bezier curves with a control point

proc drawLineStrip*(points: ptr Vector2; pointsCount: cint; color: Color) {.cdecl,
    importc: "DrawLineStrip", dynlib: raylibdll.}
##  Draw lines sequence

proc drawCircle*(centerX: cint; centerY: cint; radius: cfloat; color: Color) {.cdecl,
    importc: "DrawCircle", dynlib: raylibdll.}
##  Draw a color-filled circle

proc drawCircleSector*(center: Vector2; radius: cfloat; startAngle: cint;
                      endAngle: cint; segments: cint; color: Color) {.cdecl,
    importc: "DrawCircleSector", dynlib: raylibdll.}
##  Draw a piece of a circle

proc drawCircleSectorLines*(center: Vector2; radius: cfloat; startAngle: cint;
                           endAngle: cint; segments: cint; color: Color) {.cdecl,
    importc: "DrawCircleSectorLines", dynlib: raylibdll.}
##  Draw circle sector outline

proc drawCircleGradient*(centerX: cint; centerY: cint; radius: cfloat; color1: Color;
                        color2: Color) {.cdecl, importc: "DrawCircleGradient",
                                       dynlib: raylibdll.}
##  Draw a gradient-filled circle

proc drawCircleV*(center: Vector2; radius: cfloat; color: Color) {.cdecl,
    importc: "DrawCircleV", dynlib: raylibdll.}
##  Draw a color-filled circle (Vector version)

proc drawCircleLines*(centerX: cint; centerY: cint; radius: cfloat; color: Color) {.
    cdecl, importc: "DrawCircleLines", dynlib: raylibdll.}
##  Draw circle outline

proc drawEllipse*(centerX: cint; centerY: cint; radiusH: cfloat; radiusV: cfloat;
                 color: Color) {.cdecl, importc: "DrawEllipse", dynlib: raylibdll.}
##  Draw ellipse

proc drawEllipseLines*(centerX: cint; centerY: cint; radiusH: cfloat; radiusV: cfloat;
                      color: Color) {.cdecl, importc: "DrawEllipseLines",
                                    dynlib: raylibdll.}
##  Draw ellipse outline

proc drawRing*(center: Vector2; innerRadius: cfloat; outerRadius: cfloat;
              startAngle: cint; endAngle: cint; segments: cint; color: Color) {.cdecl,
    importc: "DrawRing", dynlib: raylibdll.}
##  Draw ring

proc drawRingLines*(center: Vector2; innerRadius: cfloat; outerRadius: cfloat;
                   startAngle: cint; endAngle: cint; segments: cint; color: Color) {.
    cdecl, importc: "DrawRingLines", dynlib: raylibdll.}
##  Draw ring outline

proc drawRectangle*(posX: cint; posY: cint; width: cint; height: cint; color: Color) {.
    cdecl, importc: "DrawRectangle", dynlib: raylibdll.}
##  Draw a color-filled rectangle

proc drawRectangleV*(position: Vector2; size: Vector2; color: Color) {.cdecl,
    importc: "DrawRectangleV", dynlib: raylibdll.}
##  Draw a color-filled rectangle (Vector version)

proc drawRectangleRec*(rec: Rectangle; color: Color) {.cdecl,
    importc: "DrawRectangleRec", dynlib: raylibdll.}
##  Draw a color-filled rectangle

proc drawRectanglePro*(rec: Rectangle; origin: Vector2; rotation: cfloat; color: Color) {.
    cdecl, importc: "DrawRectanglePro", dynlib: raylibdll.}
##  Draw a color-filled rectangle with pro parameters

proc drawRectangleGradientV*(posX: cint; posY: cint; width: cint; height: cint;
                            color1: Color; color2: Color) {.cdecl,
    importc: "DrawRectangleGradientV", dynlib: raylibdll.}
##  Draw a vertical-gradient-filled rectangle

proc drawRectangleGradientH*(posX: cint; posY: cint; width: cint; height: cint;
                            color1: Color; color2: Color) {.cdecl,
    importc: "DrawRectangleGradientH", dynlib: raylibdll.}
##  Draw a horizontal-gradient-filled rectangle

proc drawRectangleGradientEx*(rec: Rectangle; col1: Color; col2: Color; col3: Color;
                             col4: Color) {.cdecl,
    importc: "DrawRectangleGradientEx", dynlib: raylibdll.}
##  Draw a gradient-filled rectangle with custom vertex colors

proc drawRectangleLines*(posX: cint; posY: cint; width: cint; height: cint; color: Color) {.
    cdecl, importc: "DrawRectangleLines", dynlib: raylibdll.}
##  Draw rectangle outline

proc drawRectangleLinesEx*(rec: Rectangle; lineThick: cint; color: Color) {.cdecl,
    importc: "DrawRectangleLinesEx", dynlib: raylibdll.}
##  Draw rectangle outline with extended parameters

proc drawRectangleRounded*(rec: Rectangle; roundness: cfloat; segments: cint;
                          color: Color) {.cdecl, importc: "DrawRectangleRounded",
                                        dynlib: raylibdll.}
##  Draw rectangle with rounded edges

proc drawRectangleRoundedLines*(rec: Rectangle; roundness: cfloat; segments: cint;
                               lineThick: cint; color: Color) {.cdecl,
    importc: "DrawRectangleRoundedLines", dynlib: raylibdll.}
##  Draw rectangle with rounded edges outline

proc drawTriangle*(v1: Vector2; v2: Vector2; v3: Vector2; color: Color) {.cdecl,
    importc: "DrawTriangle", dynlib: raylibdll.}
##  Draw a color-filled triangle (vertex in counter-clockwise order!)

proc drawTriangleLines*(v1: Vector2; v2: Vector2; v3: Vector2; color: Color) {.cdecl,
    importc: "DrawTriangleLines", dynlib: raylibdll.}
##  Draw triangle outline (vertex in counter-clockwise order!)

proc drawTriangleFan*(points: ptr Vector2; pointsCount: cint; color: Color) {.cdecl,
    importc: "DrawTriangleFan", dynlib: raylibdll.}
##  Draw a triangle fan defined by points (first vertex is the center)

proc drawTriangleStrip*(points: ptr Vector2; pointsCount: cint; color: Color) {.cdecl,
    importc: "DrawTriangleStrip", dynlib: raylibdll.}
##  Draw a triangle strip defined by points

proc drawPoly*(center: Vector2; sides: cint; radius: cfloat; rotation: cfloat;
              color: Color) {.cdecl, importc: "DrawPoly", dynlib: raylibdll.}
##  Draw a regular polygon (Vector version)

proc drawPolyLines*(center: Vector2; sides: cint; radius: cfloat; rotation: cfloat;
                   color: Color) {.cdecl, importc: "DrawPolyLines", dynlib: raylibdll.}
##  Draw a polygon outline of n sides
##  Basic shapes collision detection functions

proc checkCollisionRecs*(rec1: Rectangle; rec2: Rectangle): bool {.cdecl,
    importc: "CheckCollisionRecs", dynlib: raylibdll.}
##  Check collision between two rectangles

proc checkCollisionCircles*(center1: Vector2; radius1: cfloat; center2: Vector2;
                           radius2: cfloat): bool {.cdecl,
    importc: "CheckCollisionCircles", dynlib: raylibdll.}
##  Check collision between two circles

proc checkCollisionCircleRec*(center: Vector2; radius: cfloat; rec: Rectangle): bool {.
    cdecl, importc: "CheckCollisionCircleRec", dynlib: raylibdll.}
##  Check collision between circle and rectangle

proc checkCollisionPointRec*(point: Vector2; rec: Rectangle): bool {.cdecl,
    importc: "CheckCollisionPointRec", dynlib: raylibdll.}
##  Check if point is inside rectangle

proc checkCollisionPointCircle*(point: Vector2; center: Vector2; radius: cfloat): bool {.
    cdecl, importc: "CheckCollisionPointCircle", dynlib: raylibdll.}
##  Check if point is inside circle

proc checkCollisionPointTriangle*(point: Vector2; p1: Vector2; p2: Vector2; p3: Vector2): bool {.
    cdecl, importc: "CheckCollisionPointTriangle", dynlib: raylibdll.}
##  Check if point is inside a triangle

proc checkCollisionLines*(startPos1: Vector2; endPos1: Vector2; startPos2: Vector2;
                         endPos2: Vector2; collisionPoint: ptr Vector2): bool {.cdecl,
    importc: "CheckCollisionLines", dynlib: raylibdll.}
##  Check the collision between two lines defined by two points each, returns collision point by reference

proc getCollisionRec*(rec1: Rectangle; rec2: Rectangle): Rectangle {.cdecl,
    importc: "GetCollisionRec", dynlib: raylibdll.}
##  Get collision rectangle for two rectangles collision
## ------------------------------------------------------------------------------------
##  Texture Loading and Drawing Functions (Module: textures)
## ------------------------------------------------------------------------------------
##  Image loading functions
##  NOTE: This functions do not require GPU access

proc loadImage*(fileName: cstring): Image {.cdecl, importc: "LoadImage",
                                        dynlib: raylibdll.}
##  Load image from file into CPU memory (RAM)

proc loadImageRaw*(fileName: cstring; width: cint; height: cint; format: cint;
                  headerSize: cint): Image {.cdecl, importc: "LoadImageRaw",
    dynlib: raylibdll.}
##  Load image from RAW file data

proc loadImageAnim*(fileName: cstring; frames: ptr cint): Image {.cdecl,
    importc: "LoadImageAnim", dynlib: raylibdll.}
##  Load image sequence from file (frames appended to image.data)

proc loadImageFromMemory*(fileType: cstring; fileData: ptr uint8; dataSize: cint): Image {.
    cdecl, importc: "LoadImageFromMemory", dynlib: raylibdll.}
##  Load image from memory buffer, fileType refers to extension: i.e. "png"

proc unloadImage*(image: Image) {.cdecl, importc: "UnloadImage", dynlib: raylibdll.}
##  Unload image from CPU memory (RAM)

proc exportImage*(image: Image; fileName: cstring): bool {.cdecl,
    importc: "ExportImage", dynlib: raylibdll.}
##  Export image data to file, returns true on success

proc exportImageAsCode*(image: Image; fileName: cstring): bool {.cdecl,
    importc: "ExportImageAsCode", dynlib: raylibdll.}
##  Export image as code file defining an array of bytes, returns true on success
##  Image generation functions

proc genImageColor*(width: cint; height: cint; color: Color): Image {.cdecl,
    importc: "GenImageColor", dynlib: raylibdll.}
##  Generate image: plain color

proc genImageGradientV*(width: cint; height: cint; top: Color; bottom: Color): Image {.
    cdecl, importc: "GenImageGradientV", dynlib: raylibdll.}
##  Generate image: vertical gradient

proc genImageGradientH*(width: cint; height: cint; left: Color; right: Color): Image {.
    cdecl, importc: "GenImageGradientH", dynlib: raylibdll.}
##  Generate image: horizontal gradient

proc genImageGradientRadial*(width: cint; height: cint; density: cfloat; inner: Color;
                            outer: Color): Image {.cdecl,
    importc: "GenImageGradientRadial", dynlib: raylibdll.}
##  Generate image: radial gradient

proc genImageChecked*(width: cint; height: cint; checksX: cint; checksY: cint;
                     col1: Color; col2: Color): Image {.cdecl,
    importc: "GenImageChecked", dynlib: raylibdll.}
##  Generate image: checked

proc genImageWhiteNoise*(width: cint; height: cint; factor: cfloat): Image {.cdecl,
    importc: "GenImageWhiteNoise", dynlib: raylibdll.}
##  Generate image: white noise

proc genImagePerlinNoise*(width: cint; height: cint; offsetX: cint; offsetY: cint;
                         scale: cfloat): Image {.cdecl,
    importc: "GenImagePerlinNoise", dynlib: raylibdll.}
##  Generate image: perlin noise

proc genImageCellular*(width: cint; height: cint; tileSize: cint): Image {.cdecl,
    importc: "GenImageCellular", dynlib: raylibdll.}
##  Generate image: cellular algorithm. Bigger tileSize means bigger cells
##  Image manipulation functions

proc imageCopy*(image: Image): Image {.cdecl, importc: "ImageCopy", dynlib: raylibdll.}
##  Create an image duplicate (useful for transformations)

proc imageFromImage*(image: Image; rec: Rectangle): Image {.cdecl,
    importc: "ImageFromImage", dynlib: raylibdll.}
##  Create an image from another image piece

proc imageText*(text: cstring; fontSize: cint; color: Color): Image {.cdecl,
    importc: "ImageText", dynlib: raylibdll.}
##  Create an image from text (default font)

proc imageTextEx*(font: Font; text: cstring; fontSize: cfloat; spacing: cfloat;
                 tint: Color): Image {.cdecl, importc: "ImageTextEx",
                                    dynlib: raylibdll.}
##  Create an image from text (custom sprite font)

proc imageFormat*(image: ptr Image; newFormat: cint) {.cdecl, importc: "ImageFormat",
    dynlib: raylibdll.}
##  Convert image data to desired format

proc imageToPOT*(image: ptr Image; fill: Color) {.cdecl, importc: "ImageToPOT",
    dynlib: raylibdll.}
##  Convert image to POT (power-of-two)

proc imageCrop*(image: ptr Image; crop: Rectangle) {.cdecl, importc: "ImageCrop",
    dynlib: raylibdll.}
##  Crop an image to a defined rectangle

proc imageAlphaCrop*(image: ptr Image; threshold: cfloat) {.cdecl,
    importc: "ImageAlphaCrop", dynlib: raylibdll.}
##  Crop image depending on alpha value

proc imageAlphaClear*(image: ptr Image; color: Color; threshold: cfloat) {.cdecl,
    importc: "ImageAlphaClear", dynlib: raylibdll.}
##  Clear alpha channel to desired color

proc imageAlphaMask*(image: ptr Image; alphaMask: Image) {.cdecl,
    importc: "ImageAlphaMask", dynlib: raylibdll.}
##  Apply alpha mask to image

proc imageAlphaPremultiply*(image: ptr Image) {.cdecl,
    importc: "ImageAlphaPremultiply", dynlib: raylibdll.}
##  Premultiply alpha channel

proc imageResize*(image: ptr Image; newWidth: cint; newHeight: cint) {.cdecl,
    importc: "ImageResize", dynlib: raylibdll.}
##  Resize image (Bicubic scaling algorithm)

proc imageResizeNN*(image: ptr Image; newWidth: cint; newHeight: cint) {.cdecl,
    importc: "ImageResizeNN", dynlib: raylibdll.}
##  Resize image (Nearest-Neighbor scaling algorithm)

proc imageResizeCanvas*(image: ptr Image; newWidth: cint; newHeight: cint;
                       offsetX: cint; offsetY: cint; fill: Color) {.cdecl,
    importc: "ImageResizeCanvas", dynlib: raylibdll.}
##  Resize canvas and fill with color

proc imageMipmaps*(image: ptr Image) {.cdecl, importc: "ImageMipmaps",
                                   dynlib: raylibdll.}
##  Generate all mipmap levels for a provided image

proc imageDither*(image: ptr Image; rBpp: cint; gBpp: cint; bBpp: cint; aBpp: cint) {.cdecl,
    importc: "ImageDither", dynlib: raylibdll.}
##  Dither image data to 16bpp or lower (Floyd-Steinberg dithering)

proc imageFlipVertical*(image: ptr Image) {.cdecl, importc: "ImageFlipVertical",
                                        dynlib: raylibdll.}
##  Flip image vertically

proc imageFlipHorizontal*(image: ptr Image) {.cdecl, importc: "ImageFlipHorizontal",
    dynlib: raylibdll.}
##  Flip image horizontally

proc imageRotateCW*(image: ptr Image) {.cdecl, importc: "ImageRotateCW",
                                    dynlib: raylibdll.}
##  Rotate image clockwise 90deg

proc imageRotateCCW*(image: ptr Image) {.cdecl, importc: "ImageRotateCCW",
                                     dynlib: raylibdll.}
##  Rotate image counter-clockwise 90deg

proc imageColorTint*(image: ptr Image; color: Color) {.cdecl,
    importc: "ImageColorTint", dynlib: raylibdll.}
##  Modify image color: tint

proc imageColorInvert*(image: ptr Image) {.cdecl, importc: "ImageColorInvert",
                                       dynlib: raylibdll.}
##  Modify image color: invert

proc imageColorGrayscale*(image: ptr Image) {.cdecl, importc: "ImageColorGrayscale",
    dynlib: raylibdll.}
##  Modify image color: grayscale

proc imageColorContrast*(image: ptr Image; contrast: cfloat) {.cdecl,
    importc: "ImageColorContrast", dynlib: raylibdll.}
##  Modify image color: contrast (-100 to 100)

proc imageColorBrightness*(image: ptr Image; brightness: cint) {.cdecl,
    importc: "ImageColorBrightness", dynlib: raylibdll.}
##  Modify image color: brightness (-255 to 255)

proc imageColorReplace*(image: ptr Image; color: Color; replace: Color) {.cdecl,
    importc: "ImageColorReplace", dynlib: raylibdll.}
##  Modify image color: replace color

proc loadImageColors*(image: Image): ptr Color {.cdecl, importc: "LoadImageColors",
    dynlib: raylibdll.}
##  Load color data from image as a Color array (RGBA - 32bit)

proc loadImagePalette*(image: Image; maxPaletteSize: cint; colorsCount: ptr cint): ptr Color {.
    cdecl, importc: "LoadImagePalette", dynlib: raylibdll.}
##  Load colors palette from image as a Color array (RGBA - 32bit)

proc unloadImageColors*(colors: ptr Color) {.cdecl, importc: "UnloadImageColors",
    dynlib: raylibdll.}
##  Unload color data loaded with LoadImageColors()

proc unloadImagePalette*(colors: ptr Color) {.cdecl, importc: "UnloadImagePalette",
    dynlib: raylibdll.}
##  Unload colors palette loaded with LoadImagePalette()

proc getImageAlphaBorder*(image: Image; threshold: cfloat): Rectangle {.cdecl,
    importc: "GetImageAlphaBorder", dynlib: raylibdll.}
##  Get image alpha border rectangle
##  Image drawing functions
##  NOTE: Image software-rendering functions (CPU)

proc imageClearBackground*(dst: ptr Image; color: Color) {.cdecl,
    importc: "ImageClearBackground", dynlib: raylibdll.}
##  Clear image background with given color

proc imageDrawPixel*(dst: ptr Image; posX: cint; posY: cint; color: Color) {.cdecl,
    importc: "ImageDrawPixel", dynlib: raylibdll.}
##  Draw pixel within an image

proc imageDrawPixelV*(dst: ptr Image; position: Vector2; color: Color) {.cdecl,
    importc: "ImageDrawPixelV", dynlib: raylibdll.}
##  Draw pixel within an image (Vector version)

proc imageDrawLine*(dst: ptr Image; startPosX: cint; startPosY: cint; endPosX: cint;
                   endPosY: cint; color: Color) {.cdecl, importc: "ImageDrawLine",
    dynlib: raylibdll.}
##  Draw line within an image

proc imageDrawLineV*(dst: ptr Image; start: Vector2; `end`: Vector2; color: Color) {.
    cdecl, importc: "ImageDrawLineV", dynlib: raylibdll.}
##  Draw line within an image (Vector version)

proc imageDrawCircle*(dst: ptr Image; centerX: cint; centerY: cint; radius: cint;
                     color: Color) {.cdecl, importc: "ImageDrawCircle",
                                   dynlib: raylibdll.}
##  Draw circle within an image

proc imageDrawCircleV*(dst: ptr Image; center: Vector2; radius: cint; color: Color) {.
    cdecl, importc: "ImageDrawCircleV", dynlib: raylibdll.}
##  Draw circle within an image (Vector version)

proc imageDrawRectangle*(dst: ptr Image; posX: cint; posY: cint; width: cint;
                        height: cint; color: Color) {.cdecl,
    importc: "ImageDrawRectangle", dynlib: raylibdll.}
##  Draw rectangle within an image

proc imageDrawRectangleV*(dst: ptr Image; position: Vector2; size: Vector2; color: Color) {.
    cdecl, importc: "ImageDrawRectangleV", dynlib: raylibdll.}
##  Draw rectangle within an image (Vector version)

proc imageDrawRectangleRec*(dst: ptr Image; rec: Rectangle; color: Color) {.cdecl,
    importc: "ImageDrawRectangleRec", dynlib: raylibdll.}
##  Draw rectangle within an image

proc imageDrawRectangleLines*(dst: ptr Image; rec: Rectangle; thick: cint; color: Color) {.
    cdecl, importc: "ImageDrawRectangleLines", dynlib: raylibdll.}
##  Draw rectangle lines within an image

proc imageDraw*(dst: ptr Image; src: Image; srcRec: Rectangle; dstRec: Rectangle;
               tint: Color) {.cdecl, importc: "ImageDraw", dynlib: raylibdll.}
##  Draw a source image within a destination image (tint applied to source)

proc imageDrawText*(dst: ptr Image; text: cstring; posX: cint; posY: cint; fontSize: cint;
                   color: Color) {.cdecl, importc: "ImageDrawText", dynlib: raylibdll.}
##  Draw text (using default font) within an image (destination)

proc imageDrawTextEx*(dst: ptr Image; font: Font; text: cstring; position: Vector2;
                     fontSize: cfloat; spacing: cfloat; tint: Color) {.cdecl,
    importc: "ImageDrawTextEx", dynlib: raylibdll.}
##  Draw text (custom sprite font) within an image (destination)
##  Texture loading functions
##  NOTE: These functions require GPU access

proc loadTexture*(fileName: cstring): Texture2D {.cdecl, importc: "LoadTexture",
    dynlib: raylibdll.}
##  Load texture from file into GPU memory (VRAM)

proc loadTextureFromImage*(image: Image): Texture2D {.cdecl,
    importc: "LoadTextureFromImage", dynlib: raylibdll.}
##  Load texture from image data

proc loadTextureCubemap*(image: Image; layoutType: cint): TextureCubemap {.cdecl,
    importc: "LoadTextureCubemap", dynlib: raylibdll.}
##  Load cubemap from image, multiple image cubemap layouts supported

proc loadRenderTexture*(width: cint; height: cint): RenderTexture2D {.cdecl,
    importc: "LoadRenderTexture", dynlib: raylibdll.}
##  Load texture for rendering (framebuffer)

proc unloadTexture*(texture: Texture2D) {.cdecl, importc: "UnloadTexture",
                                       dynlib: raylibdll.}
##  Unload texture from GPU memory (VRAM)

proc unloadRenderTexture*(target: RenderTexture2D) {.cdecl,
    importc: "UnloadRenderTexture", dynlib: raylibdll.}
##  Unload render texture from GPU memory (VRAM)

proc updateTexture*(texture: Texture2D; pixels: pointer) {.cdecl,
    importc: "UpdateTexture", dynlib: raylibdll.}
##  Update GPU texture with new data

proc updateTextureRec*(texture: Texture2D; rec: Rectangle; pixels: pointer) {.cdecl,
    importc: "UpdateTextureRec", dynlib: raylibdll.}
##  Update GPU texture rectangle with new data

proc getTextureData*(texture: Texture2D): Image {.cdecl, importc: "GetTextureData",
    dynlib: raylibdll.}
##  Get pixel data from GPU texture and return an Image

proc getScreenData*(): Image {.cdecl, importc: "GetScreenData", dynlib: raylibdll.}
##  Get pixel data from screen buffer and return an Image (screenshot)
##  Texture configuration functions

proc genTextureMipmaps*(texture: ptr Texture2D) {.cdecl,
    importc: "GenTextureMipmaps", dynlib: raylibdll.}
##  Generate GPU mipmaps for a texture

proc setTextureFilter*(texture: Texture2D; filterMode: cint) {.cdecl,
    importc: "SetTextureFilter", dynlib: raylibdll.}
##  Set texture scaling filter mode

proc setTextureWrap*(texture: Texture2D; wrapMode: cint) {.cdecl,
    importc: "SetTextureWrap", dynlib: raylibdll.}
##  Set texture wrapping mode
##  Texture drawing functions

proc drawTexture*(texture: Texture2D; posX: cint; posY: cint; tint: Color) {.cdecl,
    importc: "DrawTexture", dynlib: raylibdll.}
##  Draw a Texture2D

proc drawTextureV*(texture: Texture2D; position: Vector2; tint: Color) {.cdecl,
    importc: "DrawTextureV", dynlib: raylibdll.}
##  Draw a Texture2D with position defined as Vector2

proc drawTextureEx*(texture: Texture2D; position: Vector2; rotation: cfloat;
                   scale: cfloat; tint: Color) {.cdecl, importc: "DrawTextureEx",
    dynlib: raylibdll.}
##  Draw a Texture2D with extended parameters

proc drawTextureRec*(texture: Texture2D; source: Rectangle; position: Vector2;
                    tint: Color) {.cdecl, importc: "DrawTextureRec",
                                 dynlib: raylibdll.}
##  Draw a part of a texture defined by a rectangle

proc drawTextureQuad*(texture: Texture2D; tiling: Vector2; offset: Vector2;
                     quad: Rectangle; tint: Color) {.cdecl,
    importc: "DrawTextureQuad", dynlib: raylibdll.}
##  Draw texture quad with tiling and offset parameters

proc drawTextureTiled*(texture: Texture2D; source: Rectangle; dest: Rectangle;
                      origin: Vector2; rotation: cfloat; scale: cfloat; tint: Color) {.
    cdecl, importc: "DrawTextureTiled", dynlib: raylibdll.}
##  Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.

proc drawTexturePro*(texture: Texture2D; source: Rectangle; dest: Rectangle;
                    origin: Vector2; rotation: cfloat; tint: Color) {.cdecl,
    importc: "DrawTexturePro", dynlib: raylibdll.}
##  Draw a part of a texture defined by a rectangle with 'pro' parameters

proc drawTextureNPatch*(texture: Texture2D; nPatchInfo: NPatchInfo; dest: Rectangle;
                       origin: Vector2; rotation: cfloat; tint: Color) {.cdecl,
    importc: "DrawTextureNPatch", dynlib: raylibdll.}
##  Draws a texture (or part of it) that stretches or shrinks nicely
##  Color/pixel related functions

proc fade*(color: Color; alpha: cfloat): Color {.cdecl, importc: "Fade",
    dynlib: raylibdll.}
##  Returns color with alpha applied, alpha goes from 0.0f to 1.0f

proc colorToInt*(color: Color): cint {.cdecl, importc: "ColorToInt", dynlib: raylibdll.}
##  Returns hexadecimal value for a Color

proc colorNormalize*(color: Color): Vector4 {.cdecl, importc: "ColorNormalize",
    dynlib: raylibdll.}
##  Returns Color normalized as float [0..1]

proc colorFromNormalized*(normalized: Vector4): Color {.cdecl,
    importc: "ColorFromNormalized", dynlib: raylibdll.}
##  Returns Color from normalized values [0..1]

proc colorToHSV*(color: Color): Vector3 {.cdecl, importc: "ColorToHSV",
                                      dynlib: raylibdll.}
##  Returns HSV values for a Color

proc colorFromHSV*(hue: cfloat; saturation: cfloat; value: cfloat): Color {.cdecl,
    importc: "ColorFromHSV", dynlib: raylibdll.}
##  Returns a Color from HSV values

proc colorAlpha*(color: Color; alpha: cfloat): Color {.cdecl, importc: "ColorAlpha",
    dynlib: raylibdll.}
##  Returns color with alpha applied, alpha goes from 0.0f to 1.0f

proc colorAlphaBlend*(dst: Color; src: Color; tint: Color): Color {.cdecl,
    importc: "ColorAlphaBlend", dynlib: raylibdll.}
##  Returns src alpha-blended into dst color with tint

proc getColor*(hexValue: cint): Color {.cdecl, importc: "GetColor", dynlib: raylibdll.}
##  Get Color structure from hexadecimal value

proc getPixelColor*(srcPtr: pointer; format: cint): Color {.cdecl,
    importc: "GetPixelColor", dynlib: raylibdll.}
##  Get Color from a source pixel pointer of certain format

proc setPixelColor*(dstPtr: pointer; color: Color; format: cint) {.cdecl,
    importc: "SetPixelColor", dynlib: raylibdll.}
##  Set color formatted into destination pixel pointer

proc getPixelDataSize*(width: cint; height: cint; format: cint): cint {.cdecl,
    importc: "GetPixelDataSize", dynlib: raylibdll.}
##  Get pixel data size in bytes for certain format
## ------------------------------------------------------------------------------------
##  Font Loading and Text Drawing Functions (Module: text)
## ------------------------------------------------------------------------------------
##  Font loading/unloading functions

proc getFontDefault*(): Font {.cdecl, importc: "GetFontDefault", dynlib: raylibdll.}
##  Get the default Font

proc loadFont*(fileName: cstring): Font {.cdecl, importc: "LoadFont", dynlib: raylibdll.}
##  Load font from file into GPU memory (VRAM)

proc loadFontEx*(fileName: cstring; fontSize: cint; fontChars: ptr cint;
                charsCount: cint): Font {.cdecl, importc: "LoadFontEx",
                                       dynlib: raylibdll.}
##  Load font from file with extended parameters

proc loadFontFromImage*(image: Image; key: Color; firstChar: cint): Font {.cdecl,
    importc: "LoadFontFromImage", dynlib: raylibdll.}
##  Load font from Image (XNA style)

proc loadFontFromMemory*(fileType: cstring; fileData: ptr uint8; dataSize: cint;
                        fontSize: cint; fontChars: ptr cint; charsCount: cint): Font {.
    cdecl, importc: "LoadFontFromMemory", dynlib: raylibdll.}
##  Load font from memory buffer, fileType refers to extension: i.e. "ttf"

proc loadFontData*(fileData: ptr uint8; dataSize: cint; fontSize: cint;
                  fontChars: ptr cint; charsCount: cint; `type`: cint): ptr CharInfo {.
    cdecl, importc: "LoadFontData", dynlib: raylibdll.}
##  Load font data for further use

proc genImageFontAtlas*(chars: ptr CharInfo; recs: ptr ptr Rectangle; charsCount: cint;
                       fontSize: cint; padding: cint; packMethod: cint): Image {.cdecl,
    importc: "GenImageFontAtlas", dynlib: raylibdll.}
##  Generate image font atlas using chars info

proc unloadFontData*(chars: ptr CharInfo; charsCount: cint) {.cdecl,
    importc: "UnloadFontData", dynlib: raylibdll.}
##  Unload font chars info data (RAM)

proc unloadFont*(font: Font) {.cdecl, importc: "UnloadFont", dynlib: raylibdll.}
##  Unload Font from GPU memory (VRAM)
##  Text drawing functions

proc drawFPS*(posX: cint; posY: cint) {.cdecl, importc: "DrawFPS", dynlib: raylibdll.}
##  Shows current FPS

proc drawText*(text: cstring; posX: cint; posY: cint; fontSize: cint; color: Color) {.
    cdecl, importc: "DrawText", dynlib: raylibdll.}
##  Draw text (using default font)

proc drawTextEx*(font: Font; text: cstring; position: Vector2; fontSize: cfloat;
                spacing: cfloat; tint: Color) {.cdecl, importc: "DrawTextEx",
    dynlib: raylibdll.}
##  Draw text using font and additional parameters

proc drawTextRec*(font: Font; text: cstring; rec: Rectangle; fontSize: cfloat;
                 spacing: cfloat; wordWrap: bool; tint: Color) {.cdecl,
    importc: "DrawTextRec", dynlib: raylibdll.}
##  Draw text using font inside rectangle limits

proc drawTextRecEx*(font: Font; text: cstring; rec: Rectangle; fontSize: cfloat;
                   spacing: cfloat; wordWrap: bool; tint: Color; selectStart: cint;
                   selectLength: cint; selectTint: Color; selectBackTint: Color) {.
    cdecl, importc: "DrawTextRecEx", dynlib: raylibdll.}
##  Draw text using font inside rectangle limits with support for text selection

proc drawTextCodepoint*(font: Font; codepoint: cint; position: Vector2;
                       fontSize: cfloat; tint: Color) {.cdecl,
    importc: "DrawTextCodepoint", dynlib: raylibdll.}
##  Draw one character (codepoint)
##  Text misc. functions

proc measureText*(text: cstring; fontSize: cint): cint {.cdecl, importc: "MeasureText",
    dynlib: raylibdll.}
##  Measure string width for default font

proc measureTextEx*(font: Font; text: cstring; fontSize: cfloat; spacing: cfloat): Vector2 {.
    cdecl, importc: "MeasureTextEx", dynlib: raylibdll.}
##  Measure string size for Font

proc getGlyphIndex*(font: Font; codepoint: cint): cint {.cdecl,
    importc: "GetGlyphIndex", dynlib: raylibdll.}
##  Get index position for a unicode character on font
##  Text strings management functions (no utf8 strings, only byte chars)
##  NOTE: Some strings allocate memory internally for returned strings, just be careful!

proc textCopy*(dst: cstring; src: cstring): cint {.cdecl, importc: "TextCopy",
    dynlib: raylibdll.}
##  Copy one string to another, returns bytes copied

proc textIsEqual*(text1: cstring; text2: cstring): bool {.cdecl,
    importc: "TextIsEqual", dynlib: raylibdll.}
##  Check if two text string are equal

proc textLength*(text: cstring): cuint {.cdecl, importc: "TextLength",
                                     dynlib: raylibdll.}
##  Get text length, checks for '\0' ending

proc textFormat*(text: cstring): cstring {.varargs, cdecl, importc: "TextFormat",
                                       dynlib: raylibdll.}
##  Text formatting with variables (sprintf style)

proc textSubtext*(text: cstring; position: cint; length: cint): cstring {.cdecl,
    importc: "TextSubtext", dynlib: raylibdll.}
##  Get a piece of a text string

proc textReplace*(text: cstring; replace: cstring; by: cstring): cstring {.cdecl,
    importc: "TextReplace", dynlib: raylibdll.}
##  Replace text string (memory must be freed!)

proc textInsert*(text: cstring; insert: cstring; position: cint): cstring {.cdecl,
    importc: "TextInsert", dynlib: raylibdll.}
##  Insert text in a position (memory must be freed!)

proc textJoin*(textList: cstringArray; count: cint; delimiter: cstring): cstring {.
    cdecl, importc: "TextJoin", dynlib: raylibdll.}
##  Join text strings with delimiter

proc textSplit*(text: cstring; delimiter: char; count: ptr cint): cstringArray {.cdecl,
    importc: "TextSplit", dynlib: raylibdll.}
##  Split text into multiple strings

proc textAppend*(text: cstring; append: cstring; position: ptr cint) {.cdecl,
    importc: "TextAppend", dynlib: raylibdll.}
##  Append text at specific position and move cursor!

proc textFindIndex*(text: cstring; find: cstring): cint {.cdecl,
    importc: "TextFindIndex", dynlib: raylibdll.}
##  Find first text occurrence within a string

proc textToUpper*(text: cstring): cstring {.cdecl, importc: "TextToUpper",
                                        dynlib: raylibdll.}
##  Get upper case version of provided string

proc textToLower*(text: cstring): cstring {.cdecl, importc: "TextToLower",
                                        dynlib: raylibdll.}
##  Get lower case version of provided string

proc textToPascal*(text: cstring): cstring {.cdecl, importc: "TextToPascal",
    dynlib: raylibdll.}
##  Get Pascal case notation version of provided string

proc textToInteger*(text: cstring): cint {.cdecl, importc: "TextToInteger",
                                       dynlib: raylibdll.}
##  Get integer value from text (negative values not supported)

proc textToUtf8*(codepoints: ptr cint; length: cint): cstring {.cdecl,
    importc: "TextToUtf8", dynlib: raylibdll.}
##  Encode text codepoint into utf8 text (memory must be freed!)
##  UTF8 text strings management functions

proc getCodepoints*(text: cstring; count: ptr cint): ptr cint {.cdecl,
    importc: "GetCodepoints", dynlib: raylibdll.}
##  Get all codepoints in a string, codepoints count returned by parameters

proc getCodepointsCount*(text: cstring): cint {.cdecl, importc: "GetCodepointsCount",
    dynlib: raylibdll.}
##  Get total number of characters (codepoints) in a UTF8 encoded string

proc getNextCodepoint*(text: cstring; bytesProcessed: ptr cint): cint {.cdecl,
    importc: "GetNextCodepoint", dynlib: raylibdll.}
##  Returns next codepoint in a UTF8 encoded string; 0x3f('?') is returned on failure

proc codepointToUtf8*(codepoint: cint; byteLength: ptr cint): cstring {.cdecl,
    importc: "CodepointToUtf8", dynlib: raylibdll.}
##  Encode codepoint into utf8 text (char array length returned as parameter)
## ------------------------------------------------------------------------------------
##  Basic 3d Shapes Drawing Functions (Module: models)
## ------------------------------------------------------------------------------------
##  Basic geometric 3D shapes drawing functions

proc drawLine3D*(startPos: Vector3; endPos: Vector3; color: Color) {.cdecl,
    importc: "DrawLine3D", dynlib: raylibdll.}
##  Draw a line in 3D world space

proc drawPoint3D*(position: Vector3; color: Color) {.cdecl, importc: "DrawPoint3D",
    dynlib: raylibdll.}
##  Draw a point in 3D space, actually a small line

proc drawCircle3D*(center: Vector3; radius: cfloat; rotationAxis: Vector3;
                  rotationAngle: cfloat; color: Color) {.cdecl,
    importc: "DrawCircle3D", dynlib: raylibdll.}
##  Draw a circle in 3D world space

proc drawTriangle3D*(v1: Vector3; v2: Vector3; v3: Vector3; color: Color) {.cdecl,
    importc: "DrawTriangle3D", dynlib: raylibdll.}
##  Draw a color-filled triangle (vertex in counter-clockwise order!)

proc drawTriangleStrip3D*(points: ptr Vector3; pointsCount: cint; color: Color) {.cdecl,
    importc: "DrawTriangleStrip3D", dynlib: raylibdll.}
##  Draw a triangle strip defined by points

proc drawCube*(position: Vector3; width: cfloat; height: cfloat; length: cfloat;
              color: Color) {.cdecl, importc: "DrawCube", dynlib: raylibdll.}
##  Draw cube

proc drawCubeV*(position: Vector3; size: Vector3; color: Color) {.cdecl,
    importc: "DrawCubeV", dynlib: raylibdll.}
##  Draw cube (Vector version)

proc drawCubeWires*(position: Vector3; width: cfloat; height: cfloat; length: cfloat;
                   color: Color) {.cdecl, importc: "DrawCubeWires", dynlib: raylibdll.}
##  Draw cube wires

proc drawCubeWiresV*(position: Vector3; size: Vector3; color: Color) {.cdecl,
    importc: "DrawCubeWiresV", dynlib: raylibdll.}
##  Draw cube wires (Vector version)

proc drawCubeTexture*(texture: Texture2D; position: Vector3; width: cfloat;
                     height: cfloat; length: cfloat; color: Color) {.cdecl,
    importc: "DrawCubeTexture", dynlib: raylibdll.}
##  Draw cube textured

proc drawSphere*(centerPos: Vector3; radius: cfloat; color: Color) {.cdecl,
    importc: "DrawSphere", dynlib: raylibdll.}
##  Draw sphere

proc drawSphereEx*(centerPos: Vector3; radius: cfloat; rings: cint; slices: cint;
                  color: Color) {.cdecl, importc: "DrawSphereEx", dynlib: raylibdll.}
##  Draw sphere with extended parameters

proc drawSphereWires*(centerPos: Vector3; radius: cfloat; rings: cint; slices: cint;
                     color: Color) {.cdecl, importc: "DrawSphereWires",
                                   dynlib: raylibdll.}
##  Draw sphere wires

proc drawCylinder*(position: Vector3; radiusTop: cfloat; radiusBottom: cfloat;
                  height: cfloat; slices: cint; color: Color) {.cdecl,
    importc: "DrawCylinder", dynlib: raylibdll.}
##  Draw a cylinder/cone

proc drawCylinderWires*(position: Vector3; radiusTop: cfloat; radiusBottom: cfloat;
                       height: cfloat; slices: cint; color: Color) {.cdecl,
    importc: "DrawCylinderWires", dynlib: raylibdll.}
##  Draw a cylinder/cone wires

proc drawPlane*(centerPos: Vector3; size: Vector2; color: Color) {.cdecl,
    importc: "DrawPlane", dynlib: raylibdll.}
##  Draw a plane XZ

proc drawRay*(ray: Ray; color: Color) {.cdecl, importc: "DrawRay", dynlib: raylibdll.}
##  Draw a ray line

proc drawGrid*(slices: cint; spacing: cfloat) {.cdecl, importc: "DrawGrid",
    dynlib: raylibdll.}
##  Draw a grid (centered at (0, 0, 0))

proc drawGizmo*(position: Vector3) {.cdecl, importc: "DrawGizmo", dynlib: raylibdll.}
##  Draw simple gizmo
## ------------------------------------------------------------------------------------
##  Model 3d Loading and Drawing Functions (Module: models)
## ------------------------------------------------------------------------------------
##  Model loading/unloading functions

proc loadModel*(fileName: cstring): Model {.cdecl, importc: "LoadModel",
                                        dynlib: raylibdll.}
##  Load model from files (meshes and materials)

proc loadModelFromMesh*(mesh: Mesh): Model {.cdecl, importc: "LoadModelFromMesh",
    dynlib: raylibdll.}
##  Load model from generated mesh (default material)

proc unloadModel*(model: Model) {.cdecl, importc: "UnloadModel", dynlib: raylibdll.}
##  Unload model (including meshes) from memory (RAM and/or VRAM)

proc unloadModelKeepMeshes*(model: Model) {.cdecl, importc: "UnloadModelKeepMeshes",
    dynlib: raylibdll.}
##  Unload model (but not meshes) from memory (RAM and/or VRAM)
##  Mesh loading/unloading functions

proc loadMeshes*(fileName: cstring; meshCount: ptr cint): ptr Mesh {.cdecl,
    importc: "LoadMeshes", dynlib: raylibdll.}
##  Load meshes from model file

proc unloadMesh*(mesh: Mesh) {.cdecl, importc: "UnloadMesh", dynlib: raylibdll.}
##  Unload mesh from memory (RAM and/or VRAM)

proc exportMesh*(mesh: Mesh; fileName: cstring): bool {.cdecl, importc: "ExportMesh",
    dynlib: raylibdll.}
##  Export mesh data to file, returns true on success
##  Material loading/unloading functions

proc loadMaterials*(fileName: cstring; materialCount: ptr cint): ptr Material {.cdecl,
    importc: "LoadMaterials", dynlib: raylibdll.}
##  Load materials from model file

proc loadMaterialDefault*(): Material {.cdecl, importc: "LoadMaterialDefault",
                                     dynlib: raylibdll.}
##  Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)

proc unloadMaterial*(material: Material) {.cdecl, importc: "UnloadMaterial",
                                        dynlib: raylibdll.}
##  Unload material from GPU memory (VRAM)

proc setMaterialTexture*(material: ptr Material; mapType: cint; texture: Texture2D) {.
    cdecl, importc: "SetMaterialTexture", dynlib: raylibdll.}
##  Set texture for a material map type (MAP_DIFFUSE, MAP_SPECULAR...)

proc setModelMeshMaterial*(model: ptr Model; meshId: cint; materialId: cint) {.cdecl,
    importc: "SetModelMeshMaterial", dynlib: raylibdll.}
##  Set material for a mesh
##  Model animations loading/unloading functions

proc loadModelAnimations*(fileName: cstring; animsCount: ptr cint): ptr ModelAnimation {.
    cdecl, importc: "LoadModelAnimations", dynlib: raylibdll.}
##  Load model animations from file

proc updateModelAnimation*(model: Model; anim: ModelAnimation; frame: cint) {.cdecl,
    importc: "UpdateModelAnimation", dynlib: raylibdll.}
##  Update model animation pose

proc unloadModelAnimation*(anim: ModelAnimation) {.cdecl,
    importc: "UnloadModelAnimation", dynlib: raylibdll.}
##  Unload animation data

proc isModelAnimationValid*(model: Model; anim: ModelAnimation): bool {.cdecl,
    importc: "IsModelAnimationValid", dynlib: raylibdll.}
##  Check model animation skeleton match
##  Mesh generation functions

proc genMeshPoly*(sides: cint; radius: cfloat): Mesh {.cdecl, importc: "GenMeshPoly",
    dynlib: raylibdll.}
##  Generate polygonal mesh

proc genMeshPlane*(width: cfloat; length: cfloat; resX: cint; resZ: cint): Mesh {.cdecl,
    importc: "GenMeshPlane", dynlib: raylibdll.}
##  Generate plane mesh (with subdivisions)

proc genMeshCube*(width: cfloat; height: cfloat; length: cfloat): Mesh {.cdecl,
    importc: "GenMeshCube", dynlib: raylibdll.}
##  Generate cuboid mesh

proc genMeshSphere*(radius: cfloat; rings: cint; slices: cint): Mesh {.cdecl,
    importc: "GenMeshSphere", dynlib: raylibdll.}
##  Generate sphere mesh (standard sphere)

proc genMeshHemiSphere*(radius: cfloat; rings: cint; slices: cint): Mesh {.cdecl,
    importc: "GenMeshHemiSphere", dynlib: raylibdll.}
##  Generate half-sphere mesh (no bottom cap)

proc genMeshCylinder*(radius: cfloat; height: cfloat; slices: cint): Mesh {.cdecl,
    importc: "GenMeshCylinder", dynlib: raylibdll.}
##  Generate cylinder mesh

proc genMeshTorus*(radius: cfloat; size: cfloat; radSeg: cint; sides: cint): Mesh {.cdecl,
    importc: "GenMeshTorus", dynlib: raylibdll.}
##  Generate torus mesh

proc genMeshKnot*(radius: cfloat; size: cfloat; radSeg: cint; sides: cint): Mesh {.cdecl,
    importc: "GenMeshKnot", dynlib: raylibdll.}
##  Generate trefoil knot mesh

proc genMeshHeightmap*(heightmap: Image; size: Vector3): Mesh {.cdecl,
    importc: "GenMeshHeightmap", dynlib: raylibdll.}
##  Generate heightmap mesh from image data

proc genMeshCubicmap*(cubicmap: Image; cubeSize: Vector3): Mesh {.cdecl,
    importc: "GenMeshCubicmap", dynlib: raylibdll.}
##  Generate cubes-based map mesh from image data
##  Mesh manipulation functions

proc meshBoundingBox*(mesh: Mesh): BoundingBox {.cdecl, importc: "MeshBoundingBox",
    dynlib: raylibdll.}
##  Compute mesh bounding box limits

proc meshTangents*(mesh: ptr Mesh) {.cdecl, importc: "MeshTangents", dynlib: raylibdll.}
##  Compute mesh tangents

proc meshBinormals*(mesh: ptr Mesh) {.cdecl, importc: "MeshBinormals",
                                  dynlib: raylibdll.}
##  Compute mesh binormals

proc meshNormalsSmooth*(mesh: ptr Mesh) {.cdecl, importc: "MeshNormalsSmooth",
                                      dynlib: raylibdll.}
##  Smooth (average) vertex normals
##  Model drawing functions

proc drawModel*(model: Model; position: Vector3; scale: cfloat; tint: Color) {.cdecl,
    importc: "DrawModel", dynlib: raylibdll.}
##  Draw a model (with texture if set)

proc drawModelEx*(model: Model; position: Vector3; rotationAxis: Vector3;
                 rotationAngle: cfloat; scale: Vector3; tint: Color) {.cdecl,
    importc: "DrawModelEx", dynlib: raylibdll.}
##  Draw a model with extended parameters

proc drawModelWires*(model: Model; position: Vector3; scale: cfloat; tint: Color) {.
    cdecl, importc: "DrawModelWires", dynlib: raylibdll.}
##  Draw a model wires (with texture if set)

proc drawModelWiresEx*(model: Model; position: Vector3; rotationAxis: Vector3;
                      rotationAngle: cfloat; scale: Vector3; tint: Color) {.cdecl,
    importc: "DrawModelWiresEx", dynlib: raylibdll.}
##  Draw a model wires (with texture if set) with extended parameters

proc drawBoundingBox*(box: BoundingBox; color: Color) {.cdecl,
    importc: "DrawBoundingBox", dynlib: raylibdll.}
##  Draw bounding box (wires)

proc drawBillboard*(camera: Camera; texture: Texture2D; center: Vector3; size: cfloat;
                   tint: Color) {.cdecl, importc: "DrawBillboard", dynlib: raylibdll.}
##  Draw a billboard texture

proc drawBillboardRec*(camera: Camera; texture: Texture2D; source: Rectangle;
                      center: Vector3; size: cfloat; tint: Color) {.cdecl,
    importc: "DrawBillboardRec", dynlib: raylibdll.}
##  Draw a billboard texture defined by source
##  Collision detection functions

proc checkCollisionSpheres*(center1: Vector3; radius1: cfloat; center2: Vector3;
                           radius2: cfloat): bool {.cdecl,
    importc: "CheckCollisionSpheres", dynlib: raylibdll.}
##  Detect collision between two spheres

proc checkCollisionBoxes*(box1: BoundingBox; box2: BoundingBox): bool {.cdecl,
    importc: "CheckCollisionBoxes", dynlib: raylibdll.}
##  Detect collision between two bounding boxes

proc checkCollisionBoxSphere*(box: BoundingBox; center: Vector3; radius: cfloat): bool {.
    cdecl, importc: "CheckCollisionBoxSphere", dynlib: raylibdll.}
##  Detect collision between box and sphere

proc checkCollisionRaySphere*(ray: Ray; center: Vector3; radius: cfloat): bool {.cdecl,
    importc: "CheckCollisionRaySphere", dynlib: raylibdll.}
##  Detect collision between ray and sphere

proc checkCollisionRaySphereEx*(ray: Ray; center: Vector3; radius: cfloat;
                               collisionPoint: ptr Vector3): bool {.cdecl,
    importc: "CheckCollisionRaySphereEx", dynlib: raylibdll.}
##  Detect collision between ray and sphere, returns collision point

proc checkCollisionRayBox*(ray: Ray; box: BoundingBox): bool {.cdecl,
    importc: "CheckCollisionRayBox", dynlib: raylibdll.}
##  Detect collision between ray and box

proc getCollisionRayMesh*(ray: Ray; mesh: Mesh; transform: Matrix): RayHitInfo {.cdecl,
    importc: "GetCollisionRayMesh", dynlib: raylibdll.}
##  Get collision info between ray and mesh

proc getCollisionRayModel*(ray: Ray; model: Model): RayHitInfo {.cdecl,
    importc: "GetCollisionRayModel", dynlib: raylibdll.}
##  Get collision info between ray and model

proc getCollisionRayTriangle*(ray: Ray; p1: Vector3; p2: Vector3; p3: Vector3): RayHitInfo {.
    cdecl, importc: "GetCollisionRayTriangle", dynlib: raylibdll.}
##  Get collision info between ray and triangle

proc getCollisionRayGround*(ray: Ray; groundHeight: cfloat): RayHitInfo {.cdecl,
    importc: "GetCollisionRayGround", dynlib: raylibdll.}
##  Get collision info between ray and ground plane (Y-normal plane)
## ------------------------------------------------------------------------------------
##  Shaders System Functions (Module: rlgl)
##  NOTE: This functions are useless when using OpenGL 1.1
## ------------------------------------------------------------------------------------
##  Shader loading/unloading functions

proc loadShader*(vsFileName: cstring; fsFileName: cstring): Shader {.cdecl,
    importc: "LoadShader", dynlib: raylibdll.}
##  Load shader from files and bind default locations

proc loadShaderCode*(vsCode: cstring; fsCode: cstring): Shader {.cdecl,
    importc: "LoadShaderCode", dynlib: raylibdll.}
##  Load shader from code strings and bind default locations

proc unloadShader*(shader: Shader) {.cdecl, importc: "UnloadShader", dynlib: raylibdll.}
##  Unload shader from GPU memory (VRAM)

proc getShaderDefault*(): Shader {.cdecl, importc: "GetShaderDefault",
                                dynlib: raylibdll.}
##  Get default shader

proc getTextureDefault*(): Texture2D {.cdecl, importc: "GetTextureDefault",
                                    dynlib: raylibdll.}
##  Get default texture

proc getShapesTexture*(): Texture2D {.cdecl, importc: "GetShapesTexture",
                                   dynlib: raylibdll.}
##  Get texture to draw shapes

proc getShapesTextureRec*(): Rectangle {.cdecl, importc: "GetShapesTextureRec",
                                      dynlib: raylibdll.}
##  Get texture rectangle to draw shapes

proc setShapesTexture*(texture: Texture2D; source: Rectangle) {.cdecl,
    importc: "SetShapesTexture", dynlib: raylibdll.}
##  Define default texture used to draw shapes
##  Shader configuration functions

proc getShaderLocation*(shader: Shader; uniformName: cstring): cint {.cdecl,
    importc: "GetShaderLocation", dynlib: raylibdll.}
##  Get shader uniform location

proc getShaderLocationAttrib*(shader: Shader; attribName: cstring): cint {.cdecl,
    importc: "GetShaderLocationAttrib", dynlib: raylibdll.}
##  Get shader attribute location

proc setShaderValue*(shader: Shader; uniformLoc: cint; value: pointer;
                    uniformType: cint) {.cdecl, importc: "SetShaderValue",
                                       dynlib: raylibdll.}
##  Set shader uniform value

proc setShaderValueV*(shader: Shader; uniformLoc: cint; value: pointer;
                     uniformType: cint; count: cint) {.cdecl,
    importc: "SetShaderValueV", dynlib: raylibdll.}
##  Set shader uniform value vector

proc setShaderValueMatrix*(shader: Shader; uniformLoc: cint; mat: Matrix) {.cdecl,
    importc: "SetShaderValueMatrix", dynlib: raylibdll.}
##  Set shader uniform value (matrix 4x4)

proc setShaderValueTexture*(shader: Shader; uniformLoc: cint; texture: Texture2D) {.
    cdecl, importc: "SetShaderValueTexture", dynlib: raylibdll.}
##  Set shader uniform value for texture

proc setMatrixProjection*(proj: Matrix) {.cdecl, importc: "SetMatrixProjection",
                                       dynlib: raylibdll.}
##  Set a custom projection matrix (replaces internal projection matrix)

proc setMatrixModelview*(view: Matrix) {.cdecl, importc: "SetMatrixModelview",
                                      dynlib: raylibdll.}
##  Set a custom modelview matrix (replaces internal modelview matrix)

proc getMatrixModelview*(): Matrix {.cdecl, importc: "GetMatrixModelview",
                                  dynlib: raylibdll.}
##  Get internal modelview matrix

proc getMatrixProjection*(): Matrix {.cdecl, importc: "GetMatrixProjection",
                                   dynlib: raylibdll.}
##  Get internal projection matrix
##  Texture maps generation (PBR)
##  NOTE: Required shaders should be provided

proc genTextureCubemap*(shader: Shader; panorama: Texture2D; size: cint; format: cint): TextureCubemap {.
    cdecl, importc: "GenTextureCubemap", dynlib: raylibdll.}
##  Generate cubemap texture from 2D panorama texture

proc genTextureIrradiance*(shader: Shader; cubemap: TextureCubemap; size: cint): TextureCubemap {.
    cdecl, importc: "GenTextureIrradiance", dynlib: raylibdll.}
##  Generate irradiance texture using cubemap data

proc genTexturePrefilter*(shader: Shader; cubemap: TextureCubemap; size: cint): TextureCubemap {.
    cdecl, importc: "GenTexturePrefilter", dynlib: raylibdll.}
##  Generate prefilter texture using cubemap data

proc genTextureBRDF*(shader: Shader; size: cint): Texture2D {.cdecl,
    importc: "GenTextureBRDF", dynlib: raylibdll.}
##  Generate BRDF texture
##  Shading begin/end functions

proc beginShaderMode*(shader: Shader) {.cdecl, importc: "BeginShaderMode",
                                     dynlib: raylibdll.}
##  Begin custom shader drawing

proc endShaderMode*() {.cdecl, importc: "EndShaderMode", dynlib: raylibdll.}
##  End custom shader drawing (use default shader)

proc beginBlendMode*(mode: cint) {.cdecl, importc: "BeginBlendMode", dynlib: raylibdll.}
##  Begin blending mode (alpha, additive, multiplied)

proc endBlendMode*() {.cdecl, importc: "EndBlendMode", dynlib: raylibdll.}
##  End blending mode (reset to default: alpha blending)
##  VR control functions

proc initVrSimulator*() {.cdecl, importc: "InitVrSimulator", dynlib: raylibdll.}
##  Init VR simulator for selected device parameters

proc closeVrSimulator*() {.cdecl, importc: "CloseVrSimulator", dynlib: raylibdll.}
##  Close VR simulator for current device

proc updateVrTracking*(camera: ptr Camera) {.cdecl, importc: "UpdateVrTracking",
    dynlib: raylibdll.}
##  Update VR tracking (position and orientation) and camera

proc setVrConfiguration*(info: VrDeviceInfo; distortion: Shader) {.cdecl,
    importc: "SetVrConfiguration", dynlib: raylibdll.}
##  Set stereo rendering configuration parameters

proc isVrSimulatorReady*(): bool {.cdecl, importc: "IsVrSimulatorReady",
                                dynlib: raylibdll.}
##  Detect if VR simulator is ready

proc toggleVrMode*() {.cdecl, importc: "ToggleVrMode", dynlib: raylibdll.}
##  Enable/Disable VR experience

proc beginVrDrawing*() {.cdecl, importc: "BeginVrDrawing", dynlib: raylibdll.}
##  Begin VR simulator stereo rendering

proc endVrDrawing*() {.cdecl, importc: "EndVrDrawing", dynlib: raylibdll.}
##  End VR simulator stereo rendering
## ------------------------------------------------------------------------------------
##  Audio Loading and Playing Functions (Module: audio)
## ------------------------------------------------------------------------------------
##  Audio device management functions

proc initAudioDevice*() {.cdecl, importc: "InitAudioDevice", dynlib: raylibdll.}
##  Initialize audio device and context

proc closeAudioDevice*() {.cdecl, importc: "CloseAudioDevice", dynlib: raylibdll.}
##  Close the audio device and context

proc isAudioDeviceReady*(): bool {.cdecl, importc: "IsAudioDeviceReady",
                                dynlib: raylibdll.}
##  Check if audio device has been initialized successfully

proc setMasterVolume*(volume: cfloat) {.cdecl, importc: "SetMasterVolume",
                                     dynlib: raylibdll.}
##  Set master volume (listener)
##  Wave/Sound loading/unloading functions

proc loadWave*(fileName: cstring): Wave {.cdecl, importc: "LoadWave", dynlib: raylibdll.}
##  Load wave data from file

proc loadWaveFromMemory*(fileType: cstring; fileData: ptr uint8; dataSize: cint): Wave {.
    cdecl, importc: "LoadWaveFromMemory", dynlib: raylibdll.}
##  Load wave from memory buffer, fileType refers to extension: i.e. "wav"

proc loadSound*(fileName: cstring): Sound {.cdecl, importc: "LoadSound",
                                        dynlib: raylibdll.}
##  Load sound from file

proc loadSoundFromWave*(wave: Wave): Sound {.cdecl, importc: "LoadSoundFromWave",
    dynlib: raylibdll.}
##  Load sound from wave data

proc updateSound*(sound: Sound; data: pointer; samplesCount: cint) {.cdecl,
    importc: "UpdateSound", dynlib: raylibdll.}
##  Update sound buffer with new data

proc unloadWave*(wave: Wave) {.cdecl, importc: "UnloadWave", dynlib: raylibdll.}
##  Unload wave data

proc unloadSound*(sound: Sound) {.cdecl, importc: "UnloadSound", dynlib: raylibdll.}
##  Unload sound

proc exportWave*(wave: Wave; fileName: cstring): bool {.cdecl, importc: "ExportWave",
    dynlib: raylibdll.}
##  Export wave data to file, returns true on success

proc exportWaveAsCode*(wave: Wave; fileName: cstring): bool {.cdecl,
    importc: "ExportWaveAsCode", dynlib: raylibdll.}
##  Export wave sample data to code (.h), returns true on success
##  Wave/Sound management functions

proc playSound*(sound: Sound) {.cdecl, importc: "PlaySound", dynlib: raylibdll.}
##  Play a sound

proc stopSound*(sound: Sound) {.cdecl, importc: "StopSound", dynlib: raylibdll.}
##  Stop playing a sound

proc pauseSound*(sound: Sound) {.cdecl, importc: "PauseSound", dynlib: raylibdll.}
##  Pause a sound

proc resumeSound*(sound: Sound) {.cdecl, importc: "ResumeSound", dynlib: raylibdll.}
##  Resume a paused sound

proc playSoundMulti*(sound: Sound) {.cdecl, importc: "PlaySoundMulti",
                                  dynlib: raylibdll.}
##  Play a sound (using multichannel buffer pool)

proc stopSoundMulti*() {.cdecl, importc: "StopSoundMulti", dynlib: raylibdll.}
##  Stop any sound playing (using multichannel buffer pool)

proc getSoundsPlaying*(): cint {.cdecl, importc: "GetSoundsPlaying", dynlib: raylibdll.}
##  Get number of sounds playing in the multichannel

proc isSoundPlaying*(sound: Sound): bool {.cdecl, importc: "IsSoundPlaying",
                                       dynlib: raylibdll.}
##  Check if a sound is currently playing

proc setSoundVolume*(sound: Sound; volume: cfloat) {.cdecl, importc: "SetSoundVolume",
    dynlib: raylibdll.}
##  Set volume for a sound (1.0 is max level)

proc setSoundPitch*(sound: Sound; pitch: cfloat) {.cdecl, importc: "SetSoundPitch",
    dynlib: raylibdll.}
##  Set pitch for a sound (1.0 is base level)

proc waveFormat*(wave: ptr Wave; sampleRate: cint; sampleSize: cint; channels: cint) {.
    cdecl, importc: "WaveFormat", dynlib: raylibdll.}
##  Convert wave data to desired format

proc waveCopy*(wave: Wave): Wave {.cdecl, importc: "WaveCopy", dynlib: raylibdll.}
##  Copy a wave to a new wave

proc waveCrop*(wave: ptr Wave; initSample: cint; finalSample: cint) {.cdecl,
    importc: "WaveCrop", dynlib: raylibdll.}
##  Crop a wave to defined samples range

proc loadWaveSamples*(wave: Wave): ptr cfloat {.cdecl, importc: "LoadWaveSamples",
    dynlib: raylibdll.}
##  Load samples data from wave as a floats array

proc unloadWaveSamples*(samples: ptr cfloat) {.cdecl, importc: "UnloadWaveSamples",
    dynlib: raylibdll.}
##  Unload samples data loaded with LoadWaveSamples()
##  Music management functions

proc loadMusicStream*(fileName: cstring): Music {.cdecl, importc: "LoadMusicStream",
    dynlib: raylibdll.}
##  Load music stream from file

proc unloadMusicStream*(music: Music) {.cdecl, importc: "UnloadMusicStream",
                                     dynlib: raylibdll.}
##  Unload music stream

proc playMusicStream*(music: Music) {.cdecl, importc: "PlayMusicStream",
                                   dynlib: raylibdll.}
##  Start music playing

proc updateMusicStream*(music: Music) {.cdecl, importc: "UpdateMusicStream",
                                     dynlib: raylibdll.}
##  Updates buffers for music streaming

proc stopMusicStream*(music: Music) {.cdecl, importc: "StopMusicStream",
                                   dynlib: raylibdll.}
##  Stop music playing

proc pauseMusicStream*(music: Music) {.cdecl, importc: "PauseMusicStream",
                                    dynlib: raylibdll.}
##  Pause music playing

proc resumeMusicStream*(music: Music) {.cdecl, importc: "ResumeMusicStream",
                                     dynlib: raylibdll.}
##  Resume playing paused music

proc isMusicPlaying*(music: Music): bool {.cdecl, importc: "IsMusicPlaying",
                                       dynlib: raylibdll.}
##  Check if music is playing

proc setMusicVolume*(music: Music; volume: cfloat) {.cdecl, importc: "SetMusicVolume",
    dynlib: raylibdll.}
##  Set volume for music (1.0 is max level)

proc setMusicPitch*(music: Music; pitch: cfloat) {.cdecl, importc: "SetMusicPitch",
    dynlib: raylibdll.}
##  Set pitch for a music (1.0 is base level)

proc getMusicTimeLength*(music: Music): cfloat {.cdecl,
    importc: "GetMusicTimeLength", dynlib: raylibdll.}
##  Get music time length (in seconds)

proc getMusicTimePlayed*(music: Music): cfloat {.cdecl,
    importc: "GetMusicTimePlayed", dynlib: raylibdll.}
##  Get current music time played (in seconds)
##  AudioStream management functions

proc initAudioStream*(sampleRate: cuint; sampleSize: cuint; channels: cuint): AudioStream {.
    cdecl, importc: "InitAudioStream", dynlib: raylibdll.}
##  Init audio stream (to stream raw audio pcm data)

proc updateAudioStream*(stream: AudioStream; data: pointer; samplesCount: cint) {.
    cdecl, importc: "UpdateAudioStream", dynlib: raylibdll.}
##  Update audio stream buffers with data

proc closeAudioStream*(stream: AudioStream) {.cdecl, importc: "CloseAudioStream",
    dynlib: raylibdll.}
##  Close audio stream and free memory

proc isAudioStreamProcessed*(stream: AudioStream): bool {.cdecl,
    importc: "IsAudioStreamProcessed", dynlib: raylibdll.}
##  Check if any audio stream buffers requires refill

proc playAudioStream*(stream: AudioStream) {.cdecl, importc: "PlayAudioStream",
    dynlib: raylibdll.}
##  Play audio stream

proc pauseAudioStream*(stream: AudioStream) {.cdecl, importc: "PauseAudioStream",
    dynlib: raylibdll.}
##  Pause audio stream

proc resumeAudioStream*(stream: AudioStream) {.cdecl, importc: "ResumeAudioStream",
    dynlib: raylibdll.}
##  Resume audio stream

proc isAudioStreamPlaying*(stream: AudioStream): bool {.cdecl,
    importc: "IsAudioStreamPlaying", dynlib: raylibdll.}
##  Check if audio stream is playing

proc stopAudioStream*(stream: AudioStream) {.cdecl, importc: "StopAudioStream",
    dynlib: raylibdll.}
##  Stop audio stream

proc setAudioStreamVolume*(stream: AudioStream; volume: cfloat) {.cdecl,
    importc: "SetAudioStreamVolume", dynlib: raylibdll.}
##  Set volume for audio stream (1.0 is max level)

proc setAudioStreamPitch*(stream: AudioStream; pitch: cfloat) {.cdecl,
    importc: "SetAudioStreamPitch", dynlib: raylibdll.}
##  Set pitch for audio stream (1.0 is base level)

proc setAudioStreamBufferSizeDefault*(size: cint) {.cdecl,
    importc: "SetAudioStreamBufferSizeDefault", dynlib: raylibdll.}
##  Default size for new audio streams

converter intToUint8InColor*(self: tuple[r,g,b,a: int]): Color =
  (self.r.uint8, self.g.uint8, self.b.uint8, self.a.uint8)
const Lightgray*: Color = (r: 200, g: 200, b: 200, a: 255)
const Gray*: Color = (r: 130, g: 130, b: 130, a: 255)
const Darkgray*: Color = (r: 80, g: 80, b: 80, a: 255)
const Yellow*: Color = (r: 253, g: 249, b: 0, a: 255)
const Gold*: Color = (r: 255, g: 203, b: 0, a: 255)
const Orange*: Color = (r: 255, g: 161, b: 0, a: 255)
const Pink*: Color = (r: 255, g: 109, b: 194, a: 255)
const Red*: Color = (r: 230, g: 41, b: 55, a: 255)
const Maroon*: Color = (r: 190, g: 33, b: 55, a: 255)
const Green*: Color = (r: 0, g: 228, b: 48, a: 255)
const Lime*: Color = (r: 0, g: 158, b: 47, a: 255)
const Darkgreen*: Color = (r: 0, g: 117, b: 44, a: 255)
const Skyblue*: Color = (r: 102, g: 191, b: 255, a: 255)
const Blue*: Color = (r: 0, g: 121, b: 241, a: 255)
const Darkblue*: Color = (r: 0, g: 82, b: 172, a: 255)
const Purple*: Color = (r: 200, g: 122, b: 255, a: 255)
const Violet*: Color = (r: 135, g: 60, b: 190, a: 255)
const Darkpurple*: Color = (r: 112, g: 31, b: 126, a: 255)
const Beige*: Color = (r: 211, g: 176, b: 131, a: 255)
const Brown*: Color = (r: 127, g: 106, b: 79, a: 255)
const Darkbrown*: Color = (r: 76, g: 63, b: 47, a: 255)
const White*: Color = (r: 255, g: 255, b: 255, a: 255)
const Black*: Color = (r: 0, g: 0, b: 0, a: 255)
const Blank*: Color = (r: 0, g: 0, b: 0, a: 0)
const Magenta*: Color = (r: 255, g: 0, b: 255, a: 255)
const Raywhite*: Color = (r: 245, g: 245, b: 245, a: 255)
converter ConfigFlagToInt*(self: ConfigFlag): cuint = self.cuint
converter TraceLogTypeToInt*(self: TraceLogType): cint = self.cint
converter KeyboardKeyToInt*(self: KeyboardKey): cint = self.cint
converter AndroidButtonToInt*(self: AndroidButton): cint = self.cint
converter MouseButtonToInt*(self: MouseButton): cint = self.cint
converter MouseCursorToInt*(self: MouseCursor): cint = self.cint
converter GamepadNumberToInt*(self: GamepadNumber): cint = self.cint
converter GamepadButtonToInt*(self: GamepadButton): cint = self.cint
converter GamepadAxisToInt*(self: GamepadAxis): cint = self.cint
converter ShaderLocationIndexToInt*(self: ShaderLocationIndex): cint = self.cint
converter ShaderUniformDataTypeToInt*(self: ShaderUniformDataType): cint = self.cint
converter MaterialMapTypeToInt*(self: MaterialMapType): cint = self.cint
converter PixelFormatToInt*(self: PixelFormat): cint = self.cint
converter TextureFilterModeToInt*(self: TextureFilterMode): cint = self.cint
converter TextureWrapModeToInt*(self: TextureWrapMode): cint = self.cint
converter CubemapLayoutTypeToInt*(self: CubemapLayoutType): cint = self.cint
converter FontTypeToInt*(self: FontType): cint = self.cint
converter BlendModeToInt*(self: BlendMode): cint = self.cint
converter GestureTypeToInt*(self: GestureType): cint = self.cint
converter CameraModeToInt*(self: CameraMode): cint = self.cint
converter CameraTypeToInt*(self: CameraType): cint = self.cint
converter NPatchTypeToInt*(self: NPatchType): cint = self.cint

converter floatToCfloatInVector2*(self: tuple[x,y: float]): Vector2 =
  (self.x.cfloat, self.y.cfloat)
converter floatToCfloatInVector3*(self: tuple[x,y,z: float]): Vector3 =
  (self.x.cfloat, self.y.cfloat, self.z.cfloat)
converter floatToCfloatInVector4*(self: tuple[x,y,z,w: float]): Vector4 =
  (self.x.cfloat, self.y.cfloat, self.z.cfloat, self.w.cfloat)
converter floatToCfloatInMatrix*(self:
  tuple[m0,m4,m8, m12,
        m1,m5,m9, m13,
        m2,m6,m10,m14,
        m3,m7,m11,m15: float]
): Matrix =
  (
    self.m0.cfloat, self.m4.cfloat, self.m8.cfloat,  self.m12.cfloat,
    self.m1.cfloat, self.m5.cfloat, self.m9.cfloat,  self.m13.cfloat,
    self.m2.cfloat, self.m6.cfloat, self.m10.cfloat, self.m14.cfloat,
    self.m3.cfloat, self.m7.cfloat, self.m11.cfloat, self.m15.cfloat,
  )
converter floatToCfloatInRectangle*(self: tuple[x,y,width,height: float]): Rectangle =
  (self.x.cfloat, self.y.cfloat, self.width.cfloat, self.height.cfloat)
