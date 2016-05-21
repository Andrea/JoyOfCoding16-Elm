import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Keyboard
import Time exposing (..)
import Window
import List exposing (map, concat, indexedMap, head, drop)
import Html exposing (Html, div, text)
import Html.App as Html

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

view : Model -> Html Msg
view model = div [] [Html.text "bla"]

main =
  Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
