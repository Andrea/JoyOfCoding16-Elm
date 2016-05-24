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

type Direction = Left | Right

type alias Model =
    { x : Float, y : Float, dir : Direction }

type Msg = NoOp

init : (Model, Cmd Msg)
init =
  ({ x = 1.0, y = 2.0, dir = Right }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

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


main =
  App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
