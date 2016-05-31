import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Keyboard
import Time exposing (..)
import Text
import Window
import List exposing (map, concat, indexedMap, head, drop)
import Html exposing (Html, div, text)
import Html.App as App
import Task.Extra

type Direction = Left | Right

type alias Model =
    { x : Float, y : Float, dir : Direction, windowSize : Window.Size }

type Msg = WindowSize Window.Size

init : (Model, Cmd Msg)
init =
    let
        model = { x = 1.0, y = 2.0, dir = Right, windowSize = Window.Size 0 0 }
        cmd = Window.size |> Task.Extra.performFailproof WindowSize
    in
        (model, cmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      WindowSize newSize ->
          ( { model | windowSize = newSize }, Cmd.none)

playerScore : number
playerScore = 122

view : Model -> Html Msg
view model =
  div [] [
    (div [] [txt (Text.height 50) "The Joy of cats"]),
    (div [] [Html.text  ("Score " ++  (playerScore |> toString)) ]),
    (div [] [Html.text "GAME HERE" ]),
    (div [] [Html.text "Footer"])
  ]

textGreen : Color
textGreen =
  rgb 160 200 160

txt: (Text.Text -> Text.Text) -> String -> Html string
txt f string =
  Text.fromString string
    |> Text.color textGreen
    |> Text.monospace
    |> f
    |> leftAligned
    |> toHtml


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes WindowSize

main : Program Never
main =
  App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
