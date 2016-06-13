module DrawABox exposing (..)

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
    let
        element = Collage.collage 500 500
            [ Collage.rect 100 100
                |> Collage.filled Color.red
            ]
    in
        Html.div [] [ element |> Element.toHtml ]

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
