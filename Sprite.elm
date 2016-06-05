module Sprite exposing (..)

{-| Helpers for managing sprites and doing collision detection
-}

import Color
import Collage exposing (..)
import Element exposing (..)
import Html


{-| Sprite Model has an element and a position (assumed to be bottom left (x, y))

Position used for collision testing.
-}
type alias Model =
    { element : Element
    , x : Float
    , y : Float
    }


init : Element -> Float -> Float -> Model
init element x y =
    Model element x y


type alias BoundingBox =
    { minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


type Sprite
    = Solid Model
    | Empty Model


getBoundingBox : Model -> BoundingBox
getBoundingBox sprite =
    let
        ( width, height ) =
            Element.sizeOf sprite.element

        halfWidth =
            toFloat width / 2

        halfHeight =
            toFloat height / 2

        left =
            0 - halfWidth

        right =
            halfWidth

        top =
            halfHeight

        bottom =
            0 - halfHeight
    in
        BoundingBox left bottom right top


drawBoundingBox : Model -> Element
drawBoundingBox model =
    let
        ( width, height ) =
            Element.sizeOf model.element

        boundingBox =
            getBoundingBox model
                |> Debug.log "boundingBox"
    in
        collage width
            height
            [ path
                [ ( boundingBox.minX, boundingBox.minY )
                , ( boundingBox.minX, boundingBox.maxY )
                , ( boundingBox.maxX, boundingBox.maxY )
                , ( boundingBox.maxX, boundingBox.minY )
                , ( boundingBox.minX, boundingBox.minY )
                ]
                |> Debug.log "boundingBox Path"
                |> traced { defaultLine | color = Color.red, width = 3 }
            ]


type Msg
    = None


{-| Testing sprite rendering and bounding boxes
-}
main : Html.Html Msg
main =
    let
        sprite =
            init (Element.image 100 100 "images/obj_box001.png") 0 0

        sprite2 =
            init (Element.image 100 100 "images/obj_box002.png") 200 0

        sprite3 =
            init (Element.image 100 100 "animated-kitty.gif") 10 0
    in
        Html.div []
            [ Element.layers
                [ flow right
                    [ layers
                        [ sprite.element
                        , drawBoundingBox sprite
                        ]
                    , layers
                        [ sprite2.element
                        , drawBoundingBox sprite2
                        ]
                    ]
                , container 200
                    100
                    (bottomLeftAt (absolute (round sprite3.x)) (absolute (round sprite3.y)))
                    (layers
                        [ sprite3.element
                        , drawBoundingBox sprite3
                        ]
                    )
                ]
                |> Element.toHtml
            ]
