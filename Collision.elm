module Collision exposing (..)

{-| Perform collision testing
-}

import Map exposing (Map, getTileAtPosition, Tile)
import BoundingBox


didCollide : Map -> ( Int, Int ) -> Bool
didCollide map point =
    let
        tile =
            getTileAtPosition map point
    in
        case tile of
            Map.Solid _ ->
                True

            Map.Empty _ ->
                False


type alias Player =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    }

type CollisionAxis =
    Vertical
    | Horizontal
    | Both
    | None

{-| Perform a collision test of a player object against the map

Will returned an adjusted Player based on collision testing.
-}
updateWithCollisionCheck : Map -> Player -> Player -> (Player, CollisionAxis)
updateWithCollisionCheck map oldPlayer newPlayer =
    let
        boundingBoxX =
            BoundingBox.fromWidthAndHeight ( newPlayer.x, oldPlayer.y )
                ( newPlayer.width, newPlayer.height )

        boundingBoxY =
            BoundingBox.fromWidthAndHeight ( oldPlayer.x, newPlayer.y )
                ( newPlayer.width, newPlayer.height )

        checkCollision =
            \point -> didCollide map point

        collideX =
            BoundingBox.corners boundingBoxX |> List.any checkCollision

        collideY =
            BoundingBox.corners boundingBoxY |> List.any checkCollision
    in
        case ( collideX, collideY ) of
            ( True, True ) ->
                (oldPlayer, Both)

            ( True, False ) ->
                ({ newPlayer | x = oldPlayer.x }, Horizontal)

            ( False, True ) ->
                ({ newPlayer | y = oldPlayer.y }, Vertical)

            _ ->
                (newPlayer, None)
