# ******************************************************************************************
#
#    raylib [core] example - 2d camera platformer
#
#    This example has been created using raylib 2.5 (www.raylib.com)
#    raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
#
#    Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
#
#    Copyright (c) 2019 arvyy (@arvyy)
#    Converted in 2021 by greenfork
#
# ******************************************************************************************

import lenientops
import ../../src/nimraylib_now/[raylib, raymath]

const
  G* = 400
  PLAYER_JUMP_SPD*: float32 = 350.0
  PLAYER_HOR_SPD*: float32 = 200.0

type
  Player* = object
    position*: Vector2
    speed*: float32
    canJump*: bool

  EnvItem* = object
    rect*: Rectangle
    blocking*: int32
    color*: Color

proc updatePlayer*(player: var Player; envItems: var openArray[EnvItem];  delta: float32)
proc updateCameraCenter*(camera: var Camera2D; player: var Player;
                        envItems: var openArray[EnvItem]; delta: float32;
                        width: int32; height: int32)
proc updateCameraCenterInsideMap*(camera: var Camera2D; player: var Player;
                                 envItems: var openArray[EnvItem];
                                 delta: float32; width: int32; height: int32)
proc updateCameraCenterSmoothFollow*(camera: var Camera2D; player: var Player;
                                    envItems: var openArray[EnvItem];
                                    delta: float32; width: int32; height: int32)
proc updateCameraEvenOutOnLanding*(camera: var Camera2D; player: var Player;
                                  envItems: var openArray[EnvItem];
                                  delta: float32; width: int32; height: int32)
proc updateCameraPlayerBoundsPush*(camera: var Camera2D; player: var Player;
                                  envItems: var openArray[EnvItem];
                                  delta: float32; width: int32; height: int32)
##  Initialization
## --------------------------------------------------------------------------------------
var screenWidth: int32 = 800
var screenHeight: int32 = 450
initWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
var player = Player()
player.position = Vector2(x: 400, y: 280);
player.speed = 0
player.canJump = false
var envItems = [
  EnvItem(rect: Rectangle(x: 0, y: 0, width: 1000, height: 400), blocking: 0, color: Lightgray),
  EnvItem(rect: Rectangle(x: 0, y: 400, width: 1000, height: 200), blocking: 1, color: Gray),
  EnvItem(rect: Rectangle(x: 300, y: 200, width: 400, height: 10), blocking: 1, color: Gray),
  EnvItem(rect: Rectangle(x: 250, y: 300, width: 100, height: 10), blocking: 1, color: Gray),
  EnvItem(rect: Rectangle(x: 650, y: 300, width: 100, height: 10), blocking: 1, color: Gray),
]
var camera = Camera2D()
camera.target = player.position
camera.offset = Vector2(x: screenWidth/2, y: screenHeight/2)
camera.rotation = 0.0
camera.zoom = 1.0
##  Store multiple update camera functions
let cameraUpdaters = [
   updateCameraCenter,
   updateCameraCenterInsideMap,
   updateCameraCenterSmoothFollow,
   updateCameraEvenOutOnLanding,
   updateCameraPlayerBoundsPush,
]
var cameraOption = 0
var cameraDescriptions = ["Follow player center", "Follow player center, but clamp to map edges",
                          "Follow player center; smoothed", "Follow player center horizontally; updateplayer center vertically after landing", "Player push camera on getting too close to screen edge"]
setTargetFPS(60)
## --------------------------------------------------------------------------------------
##  Main game loop
while not windowShouldClose():
  ##  Update
  ## ----------------------------------------------------------------------------------
  var deltaTime: float32 = getFrameTime()
  updatePlayer(player, envItems, deltaTime)
  camera.zoom += getMouseWheelMove() * 0.05
  if camera.zoom > 3.0:
    camera.zoom = 3.0
  elif camera.zoom < 0.25:
    camera.zoom = 0.25
  if isKeyPressed(R):
    camera.zoom = 1.0
    player.position = Vector2(x: 400, y: 280);
  if isKeyPressed(C):
    cameraOption = (cameraOption + 1) mod cameraUpdaters.len
  cameraUpdaters[cameraOption](camera, player, envItems,
                               deltaTime, screenWidth,
                               screenHeight)
  ## ----------------------------------------------------------------------------------
  ##  Draw
  ## ----------------------------------------------------------------------------------
  beginDrawing()
  clearBackground(Lightgray)
  beginMode2D(camera)
  var i: int32 = 0
  while i < envItems.len:
    drawRectangleRec(envItems[i].rect, envItems[i].color)
    inc(i)
  var playerRect = Rectangle(x: player.position.x - 20, y: player.position.y - 40, width: 40, height: 40)
  drawRectangleRec(playerRect, Red)
  endMode2D()
  drawText("Controls:", 20, 20, 10, Black)
  drawText("- Right/Left to move", 40, 40, 10, Darkgray)
  drawText("- Space to jump", 40, 60, 10, Darkgray)
  drawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, Darkgray)
  drawText("- C to change camera mode", 40, 100, 10, Darkgray)
  drawText("Current camera mode:", 20, 120, 10, Black)
  drawText(cameraDescriptions[cameraOption], 40, 140, 10, Darkgray)
  endDrawing()

## ----------------------------------------------------------------------------------
##  De-Initialization
## --------------------------------------------------------------------------------------
closeWindow()
##  Close window and OpenGL context
## --------------------------------------------------------------------------------------

proc updatePlayer*(player: var Player; envItems: var openArray[EnvItem]; delta: float32) =
  if isKeyDown(Left):
    player.position.x -= PLAYER_HOR_SPD * delta
  if isKeyDown(Right):
    player.position.x += PLAYER_JUMP_SPD * delta
  if isKeyDown(Space) and player.canJump:
    player.speed = -PLAYER_JUMP_SPD
    player.canJump = false
  var hitObstacle: int32 = 0
  var i: int32 = 0
  while i < envItems.len:
    var ei = envItems[i]
    var p = addr(player.position)
    if ei.blocking == 1 and ei.rect.x <= p.x and ei.rect.x + ei.rect.width >= p.x and
        ei.rect.y >= p.y and ei.rect.y < p.y + player.speed * delta:
      hitObstacle = 1
      player.speed = 0.0
      p.y = ei.rect.y
    inc(i)
  if hitObstacle == 0:
    player.position.y += player.speed * delta
    player.speed += G * delta
    player.canJump = false
  else:
    player.canJump = true

proc updateCameraCenter*(camera: var Camera2D; player: var Player;
                        envItems: var openArray[EnvItem]; delta: float32;
                        width: int32; height: int32) =
  camera.offset = Vector2(x: width/2, y: height/2);
  camera.target = player.position

proc updateCameraCenterInsideMap*(camera: var Camera2D; player: var Player;
                                 envItems: var openArray[EnvItem];
                                 delta: float32; width: int32; height: int32) =
  camera.target = player.position
  camera.offset = Vector2(x: width/2, y: height/2);
  var
    minX: float32 = 1000
    minY: float32 = 1000
    maxX: float32 = -1000
    maxY: float32 = -1000
  var i: int32 = 0
  while i < envItems.len:
    var ei = envItems[i]
    minX = min(ei.rect.x, minX)
    maxX = max(ei.rect.x + ei.rect.width, maxX)
    minY = min(ei.rect.y, minY)
    maxY = max(ei.rect.y + ei.rect.height, maxY)
    inc(i)
  let
    maxV = getWorldToScreen2D(Vector2(x: maxX, y: maxY), camera)
    minV = getWorldToScreen2D(Vector2(x: minX, y: minY), camera)
  if maxV.x < width:
    camera.offset.x = width - (maxV.x - width div 2)
  if maxV.y < height:
    camera.offset.y = height - (maxV.y - height div 2)
  if minV.x > 0:
    camera.offset.x = width div 2 - minV.x
  if minV.y > 0:
    camera.offset.y = height div 2 - minV.y

proc updateCameraCenterSmoothFollow*(camera: var Camera2D; player: var Player;
                                    envItems: var openArray[EnvItem];
                                    delta: float32; width: int32; height: int32) =
  var minSpeed: float32 = 30
  var minEffectLength: float32 = 10
  var fractionSpeed: float32 = 0.8
  camera.offset = Vector2(x: width/2, y: height/2);
  var diff: Vector2 = vector2Subtract(player.position, camera.target)
  var length: float32 = vector2Length(diff)
  if length > minEffectLength:
    var speed: float32 = max(fractionSpeed * length, minSpeed)
    camera.target = vector2Add(camera.target,
                             vector2Scale(diff, speed * delta / length))

var eveningOut = false
var evenOutTarget: float32
proc updateCameraEvenOutOnLanding*(camera: var Camera2D; player: var Player;
                                  envItems: var openArray[EnvItem];
                                  delta: float32; width: int32; height: int32) =
  var evenOutSpeed: float32 = 700
  camera.offset = Vector2(x: width/2, y: height/2);
  camera.target.x = player.position.x
  if eveningOut:
    if evenOutTarget > camera.target.y:
      camera.target.y += evenOutSpeed * delta
      if camera.target.y > evenOutTarget:
        camera.target.y = evenOutTarget
        eveningOut = false
    else:
      camera.target.y -= evenOutSpeed * delta
      if camera.target.y < evenOutTarget:
        camera.target.y = evenOutTarget
        eveningOut = false
  else:
    if player.canJump and player.speed == 0 and
       player.position.y != camera.target.y:
      eveningOut = true
      evenOutTarget = player.position.y

proc updateCameraPlayerBoundsPush*(camera: var Camera2D; player: var Player;
                                  envItems: var openArray[EnvItem];
                                  delta: float32; width: int32; height: int32) =
  var
    bbox = Vector2(x: 0.2, y: 0.2)
    bboxWorldMin = getScreenToWorld2D(
      Vector2(x: (1 - bbox.x)*0.5f*width, y: (1 - bbox.y)*0.5f*height),
      camera
    )
    bboxWorldMax = getScreenToWorld2D(
      Vector2(x: (1 + bbox.x)*0.5f*width, y: (1 + bbox.y)*0.5f*height),
      camera
    )
  camera.offset = Vector2(x: (1 - bbox.x)*0.5f * width, y: (1 - bbox.y)*0.5f*height);
  if player.position.x < bboxWorldMin.x:
    camera.target.x = player.position.x
  if player.position.y < bboxWorldMin.y:
    camera.target.y = player.position.y
  if player.position.x > bboxWorldMax.x:
    camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x)
  if player.position.y > bboxWorldMax.y:
    camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y)