module Collision exposing (..)

{-| Perform collision testing
-}

import Map exposing (Map, getTileAtPosition)


type alias Collision =
    {}


checkCollision : Map -> ( Float, Float ) -> Maybe Collision
checkCollision map point =
    let
        tile =
            getTileAtPosition map point

        _ =
            Debug.log "collision?" ( point, tile )
    in
        case tile of
            Map.Solid _ ->
                Just Collision

            Map.Empty _ ->
                Nothing
