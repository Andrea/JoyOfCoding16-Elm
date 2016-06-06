module Level exposing (..)

import Element exposing (..)
import Html exposing (..)
import Map


type alias Model =
    { map : Map.Map }


init : Model
init =
    Model Map.init


render : Model -> Html Msg
render model =
    let
        ( w, h ) =
            Map.mapSize model.map
    in
        div []
            [ layers
                [ tiledImage w h "images/Wall.png"
                , Map.renderMap model.map
                ]
                |> toHtml
            ]


type Msg
    = None


main : Html.Html Msg
main =
    div [] [ render init ]
