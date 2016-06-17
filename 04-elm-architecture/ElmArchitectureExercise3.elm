{-| Now draw something in a full elm architecture

Showing how things plug together

-}

import Collage
import Color
import Element
import Html
import Html.App

type alias Model = {}

type Msg = Nothing

init : (Model, Cmd Msg)
init =
    ({}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

view : Model -> Html.Html Msg
view model =
    -- Collage goes here!
    Html.div [] []

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
