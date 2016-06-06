module Map exposing (..)

{-| The map of the level. Contains the tiles and code to render them.
-}

import Element exposing (..)
import Html


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


{-| Given an (x,y) co-ordinate, origin on bottom left, return the tile at that point.

You can use this to test for collisions (e.g. get the tile at the edge in the direction of motion).

TODO: Decide whether that's the best origin :)
-}
getTileAtPosition : Map -> ( Float, Float ) -> Tile
getTileAtPosition map ( x, y ) =
    let
        colIndex =
            floor (x / toFloat tileWidth)

        rowIndex =
            floor (y / toFloat tileHeight)

        -- _ =
        --     Debug.log "x,y -> position" ( ( x, y ), ( colIndex, rowIndex ) )
        -- Helper to get at a particular index in a list, alternative -s |> List.drop idx |> List.head
        get idx =
            \list -> List.head (List.drop idx list)
    in
        map
            |> List.reverse
            |> get rowIndex
            |> Maybe.withDefault []
            |> get colIndex
            |> Maybe.withDefault (Empty (tileImage "images/obj_crate001.png"))


renderMap : Map -> Element
renderMap map =
    map
        |> List.map (List.map getElementFromTile >> flow right)
        |> flow down


type Msg
    = None


{-| Testing sprite rendering and bounding boxes
-}
main : Html.Html Msg
main =
    let
        map =
            init

        tiles =
            [ getTileAtPosition map ( 0, 0 )
            , getTileAtPosition map ( 101.5, 99 )
            , getTileAtPosition map ( 301.5, 120 )
            ]
    in
        Html.div []
            [ Element.layers
                [ renderMap map
                , List.map getElementFromTile tiles |> flow right
                ]
                |> Element.toHtml
            ]
