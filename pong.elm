-- See this document for more information on making Pong:
-- http://elm-lang.org/blog/pong
import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Keyboard
import Text
import Time exposing (..)
import Window exposing (Size)
import Html.App as App
import Html exposing (..)
import AnimationFrame
import Task


-- MODEL

(gameWidth,gameHeight) = (600,400)
(halfWidth,halfHeight) = (300,200)


type State = Play | Pause


type alias Ball =
  { x : Float
  , y : Float
  , vx : Float
  , vy : Float
  }


type alias Player =
  { x : Float
  , y : Float
  , vx : Float
  , vy : Float
  , dir : Int
  , score : Int
  }


type alias Model =
  { state : State
  , ball : Ball
  , player1 : Player
  , player2 : Player
  , size : Size
  }


player : Float -> Player
player x =
  Player x 0 0 0 0 0


defaultModel : Model
defaultModel =
  { state = Pause
  , ball = Ball 0 0 200 200
  , player1 = player (20-halfWidth)
  , player2 = player (halfWidth-20)
  , size = Size 0 0
  }

init =
  (defaultModel, Task.perform (\_ -> NoOp) Resize (Window.size))


-- UPDATE

type Msg
  = Resize Size
  | Player1 Int
  | Player2 Int
  | Tick Time
  | TogglePlay
  | NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Resize size -> { model | size = size }

    Player1 dir ->
      let
        { player1 } = model
      in
        { model | player1 = { player1 | dir = dir} }

    Player2 dir ->
      let
        { player2 } = model
      in
        { model | player2 = { player2 | dir = dir } }

    TogglePlay ->
      let
        newState =
          case model.state of
            Play -> Pause
            Pause -> Play
      in
        { model | state = newState }

    Tick delta ->
      let
        { state, ball, player1, player2 } = model
        score1 =
          if ball.x > halfWidth then 1 else 0

        score2 =
          if ball.x < -halfWidth then 1 else 0

        newState =
          if score1 /= score2 then Pause else state

        newBall =
          if state == Pause then
            ball
          else
            updateBall delta ball player1 player2
      in
        { model |
            state = newState,
            ball = newBall,
            player1 = updatePlayer delta score1 player1,
            player2 = updatePlayer delta score2 player2
        }


updateBall : Time -> Ball -> Player -> Player -> Ball
updateBall dt ball paddle1 paddle2 =
  if not (near 0 halfWidth ball.x) then
    { ball | x = 0, y = 0 }
  else
    physicsUpdate dt
      { ball |
          vx = stepV ball.vx (within paddle1 ball) (within paddle2 ball),
          vy = stepV ball.vy (ball.y < 7 - halfHeight) (ball.y > halfHeight - 7)
      }

updatePlayer : Time -> Int -> Player -> Player
updatePlayer dt points player =
  let
    movedPlayer =
      physicsUpdate dt { player | vy = toFloat player.dir * 600 }
  in
    { movedPlayer |
        y = clamp (22-halfHeight) (halfHeight-22) movedPlayer.y,
        score = player.score + points
    }


physicsUpdate dt obj =
  { obj |
      x = obj.x + obj.vx * dt,
      y = obj.y + obj.vy * dt
  }


near k c n =
  n >= k-c && n <= k+c

within paddle ball =
  near paddle.x 8 ball.x && near paddle.y 20 ball.y


stepV v lowerCollision upperCollision =
  if lowerCollision then
      abs v

  else if upperCollision then
      -(abs v)

  else
      v


-- VIEW

view : Model -> Html Msg
view model =
  let
    {ball, player1, player2, state} = model
    {width, height} = model.size
    scores =
      txt (Text.height 50) (toString player1.score ++ "  " ++ toString player2.score)
  in
    toHtml <|
    container width height middle <|
    collage gameWidth gameHeight
      [ rect gameWidth gameHeight
          |> filled pongGreen
      , oval 15 15
          |> make ball
      , rect 10 40
          |> make player1
      , rect 10 40
          |> make player2
      , toForm scores
          |> move (0, gameHeight/2 - 40)
      , toForm (if state == Play then spacer 1 1 else txt identity msg)
          |> move (0, 40 - gameHeight/2)
      ]


pongGreen =
  rgb 60 100 60


textGreen =
  rgb 160 200 160


txt f string =
  Text.fromString string
    |> Text.color textGreen
    |> Text.monospace
    |> f
    |> leftAligned


msg = "SPACE to start, WS and &uarr;&darr; to move"

make obj shape =
  shape
    |> filled white
    |> move (obj.x, obj.y)


-- WIRING

keyboardProcessor down keyCode =
  case (down, keyCode) of
    (True, 87) -> Player1 1
    (True, 83) -> Player1 -1
    (False, 87) -> Player1 0
    (False, 83) -> Player1 0

    (True, 38) -> Player2 1
    (True, 40) -> Player2 -1
    (False, 38) -> Player2 0
    (False, 40) -> Player2 0

    (False, 32) -> TogglePlay
    _ -> NoOp


main =
  App.program
    { init = init
    , update = \msg m -> update msg m ! []
    , view = view
    , subscriptions =
      (\_ -> Sub.batch
        [ Window.resizes Resize
        , Keyboard.downs (keyboardProcessor True)
        , Keyboard.ups (keyboardProcessor False)
        , AnimationFrame.diffs (Tick<<inSeconds)
        ])
    }
