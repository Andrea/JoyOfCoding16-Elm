module Level exposing (..)

import Element exposing (..)
import Html exposing (..)
import Html.App as App
import Map


type alias Model =
    { map : Map.Map }


type Msg
    = None


init : ( Model, Cmd Msg )
init =
    Model Map.init ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []


renderMap : Map.Map -> Element
renderMap map =
    List.map (List.map Map.getElementFromTile >> flow right) map
        |> flow down


render : Int -> Int -> Model -> Html Msg
render width height model =
    let
        ( w, h ) =
            Map.mapSize model.map
    in
        div []
            [ layers
                [ tiledImage w h "images/Wall.png"
                , renderMap model.map
                ]
                |> toHtml
            ]


{-| View for testing level. Not normally used in the game.
-}
view : Model -> Html Msg
view model =
    div [] [ render 800 400 model ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
