module Level exposing (..)

import Element exposing (..)
import Html exposing (..)
import Html.App as App


type alias Model =
    {}


type Msg
    = None


{-| A tile can be solid (requires collision detection) or empty
-}
type Tile
    = Solid Element
    | Empty Element


type alias Row =
    List Tile


type alias Map =
    List Row


map : Map
map =
    let
        e = Empty emptyTile
        c = Solid crateTile
    in
        [ [ e, e, e, e, e, e, e ]
        , [ e, e, e, e, e, e, e ]
        , [ e, e, e, e, e, c, e ]
        , [ e, c, e, e, c, c, e ]
        ]

getElementFromTile : Tile -> Element
getElementFromTile tile =
    case tile of
        Solid element -> element
        Empty element -> element

mapSize : Map -> ( Int, Int )
mapSize map =
    let
        ( tileWidth, tileHeight ) =
            tileSize

        row =
            case List.head map of
                Nothing ->
                    []

                Just row ->
                    row
    in
        ( List.length row * tileWidth, List.length map * tileHeight )


init : ( Model, Cmd Msg )
init =
    Model ! []


tileSize : ( Int, Int )
tileSize =
    ( 100, 100 )


makeTile : (Int -> Int -> tile) -> tile
makeTile tile =
    let
        ( w, h ) =
            tileSize
    in
        tile w h


tileImage : String -> Element
tileImage img =
    img |> makeTile image


crateTile : Element
crateTile =
    tileImage "images/obj_box002.png"


emptyTile : Element
emptyTile =
    makeTile spacer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []

renderMap : Map -> Element
renderMap map =
    List.map (List.map getElementFromTile >> flow right) map
    |> flow down

render : Int -> Int -> Model -> Html Msg
render width height model =
    let
        (w, h) = mapSize map
    in
        div []
            [ layers
                [ tiledImage w h "images/Wall.png"
                , renderMap map
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
