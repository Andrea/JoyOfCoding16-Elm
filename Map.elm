module Map exposing (..)

{-| The map of the level. Contains the tiles and code to render them.
-}

import Element exposing (..)


{-| A tile can be solid (requires collision detection) or empty
-}
type Tile
    = Solid Element
    | Empty Element


type alias Row =
    List Tile


type alias Map =
    List Row


init : Map
init =
    let
        e =
            Empty emptyTile

        c =
            Solid crateTile
    in
        [ [ e, e, e, e, e, e, e ]
        , [ e, e, e, e, e, e, e ]
        , [ e, e, e, e, e, c, e ]
        , [ e, c, e, e, c, c, e ]
        ]


getElementFromTile : Tile -> Element
getElementFromTile tile =
    case tile of
        Solid element ->
            element

        Empty element ->
            element


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


tileWidth : Int
tileWidth =
    100


tileHeight : Int
tileHeight =
    100


tileSize : ( Int, Int )
tileSize =
    ( tileWidth, tileHeight )


{-| Helper to create tiles at the default size
-}
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


getTileAtPosition : Map -> ( Float, Float ) -> Tile
getTileAtPosition map ( x, y ) =
    Empty emptyTile
