import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Keyboard
import Time exposing (..)
import Window
import List exposing (map, concat, indexedMap, head, drop)

-- MODEL

type alias Model =
  { x : Float
  , y : Float
  , vx : Float
  , vy : Float
  , dir : Direction
  }

type alias Keys = { x:Int, y:Int }

type Direction
    = Left
    | Right
    | Up
    | Down
    | None                

cat : Model
cat =
  { x = 0
  , y = 0
  , vx = 0
  , vy = 0
  , dir = Right
  }

type alias Grid = List Tile --more than 1 layer

type Tile
    =  Collision
    | NoCollision --BackGroundTile
--    | Shadow ShadowTile


-- Values

gridSize = 15
tileSize = 64

-- UPDATE

update : (Float, Keys) -> Model -> Model
update (dt, keys) mario =
  mario
    |> gravity dt
    |> jump keys
    |> walk keys
    |> physics dt


jump : Keys -> Model -> Model
jump keys mario =
  if keys.y > 0 && mario.vy == 0 then
      { mario | vy = 6.0 }

  else
      mario


gravity : Float -> Model -> Model
gravity dt mario =
  { mario |
      vy = if mario.y > 0 then mario.vy - dt/4 else 0
  }


physics : Float -> Model -> Model
physics dt mario =
  { mario |
      x = mario.x + dt * mario.vx,
      y = max 0 (mario.y + dt * mario.vy)
  }


walk : Keys -> Model -> Model
walk keys mario =
  { mario |
      vx = toFloat keys.x,
      dir =
        if keys.x < 0 then
            Left

        else if keys.x > 0 then
            Right

        else
            mario.dir
  }

getListIdx: Int -> Grid -> Maybe Tile
getListIdx idx list =
    head (drop idx list)
         
getTileIdxFromPosition : (Float, Float) -> Int
getTileIdxFromPosition (x, y) =
    let
      x_tile = (round x) + 7
      y_tile = 8 - (round y)
    in
      (y_tile - 1) * gridSize + x_tile
                   
movePlayer : Direction -> Model -> Model
movePlayer dir model =
  let
    checkPc default pc =
      let
        x = pc.x |> Debug.watch "pc x"
        y = pc.y |> Debug.watch "pc y"
        idx = getTileIdxFromPosition (pc.x, pc.y) |> Debug.watch "idx"
        tile = getListIdx idx model.grid |> Debug.watch "tile"
      in
        case tile of
          Nothing -> pc
          Just tilet -> if tilet == NoCollision then pc else default
    updatePc pc dir =
      pc
    {- case dir of
       Up ->  { pc |  y = pc.y + 1,dir = Up }
       Down -> { pc | y = pc.y - 1, dir = Down }
        Left -> { pc | x = pc.x - 1, dir = Left }
        Right -> { pc | x = pc.x + 1, dir = Right }
        None -> pc  -}
  in
    { model | pc = (checkPc model.pc (updatePc model.pc dir)) }
      

-- VIEW

view : (Int, Int) -> Model -> Element
view (w',h') mario =
  let
    (w,h) = (toFloat w', toFloat h')

    verb =
      if mario.y > 0 then
          "jump"

      else if mario.vx /= 0 then
          "walk"

      else
          "stand"

    dir =
      case mario.dir of
        Left -> "left"
        Right -> "right"

    src =
      "/imgs/cat/"++ verb ++ "/" ++ dir ++ ".gif" --DO other formats work

    marioImage =
      image 35 35 src

    groundY = 62 - h/2

    position =
      (mario.x, mario.y + groundY)
  in
    collage w' h'
      [ rect w h
          |> filled (rgb 174 238 238)
      , rect w 50
          |> filled (rgb 74 167 43)
          |> move (0, 24 - h/2)
      , marioImage
          |> toForm
          |> move position
      ]


-- SIGNALS

main : Signal Element
main =
  Signal.map2 view Window.dimensions (Signal.foldp update cat input)


input : Signal (Float, Keys)
input =
  let
    delta = Signal.map (\t -> t/20) (fps 30)
  in
    Signal.sampleOn delta (Signal.map2 (,) delta Keyboard.arrows)
