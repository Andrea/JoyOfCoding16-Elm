module BoundingBox exposing (..)

{-| Simple bounding box helpers
-}

import Element


type alias Point =
    ( Int, Int )


type alias BoundingBox =
    { minX : Int
    , minY : Int
    , maxX : Int
    , maxY : Int
    }


{-| Convert an element to a BoundingBox.

Assumes (x,y) is in the bottom left.
-}
fromElement : ( Int, Int ) -> Element.Element -> BoundingBox
fromElement point element =
    fromWidthAndHeight point (Element.sizeOf element)


fromWidthAndHeight : ( Int, Int ) -> ( Int, Int ) -> BoundingBox
fromWidthAndHeight ( x, y ) ( width, height ) =
    -- Don't forget it's 0 -> 99 for 100 px width :)
    BoundingBox x y (x + width - 1) (y + height - 1)


corners : BoundingBox -> List Point
corners bb =
    [ ( bb.minX, bb.minY )
    , ( bb.minX, bb.maxY )
    , ( bb.maxX, bb.maxY )
    , ( bb.maxX, bb.minY )
    ]


{-| Perform an axis aligned collision detection between two BoundingBoxes.
-}
overlaps : BoundingBox -> BoundingBox -> Bool
overlaps first second =
    (first.minX < second.maxX)
        && (first.maxX > second.minX)
        && (first.minY < second.maxY)
        && (first.maxY > second.minY)
