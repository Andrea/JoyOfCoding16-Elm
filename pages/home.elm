
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import String

import Center
import Skeleton



main =
    div []
    [ splash
    , content
    ]


(=>) = (,)



-- SPLASH


splash =
  div [ id "splash" ]
    [ div [ size 100 16 ] [ text "Elm Workshop" ]
    , div [ size 26 8 ] [ text "Joy of Coding 2016" ]
    -- , div [ size 26 30 ]
    --     [ a [ href "/try" ] [ text "try" ]
    --     ]
    ]


size height padding =
  style
    [ "font-size" => (toString height ++ "px")
    , "padding" => (toString padding ++ "px 0")
    ]

content =
    section [ style [ "text-align" => "left", "padding" => "2em" ] ] [
        Markdown.toHtml [] """
# Code

## Hello World

### Exercises

- [Exercise01.elm](/examples/Exercise01) 

## Elm Architecture

- [ElmArchitectureBeginnerProgram.elm](/examples/ElmArchitectureBeginnerProgram)
- [ElmArchitectureProgram.elm](/examples/ElmArchitectureProgram)

### Exercises

- [Exercise0201](/examples/Exercise0201)
- [Exercise0202](/examples/Exercise0202)

## Menus & HTML

- [MenusAndHtml.elm](/examples/MenusAndHtml)

## Elm Graphics

- [DrawABox.elm](/examples/DrawABox)

## Element & Collage

- [ElementAndCollage.elm](/examples/ElementAndCollage)

## Move a Box

- [MoveBox.elm](/examples/MoveBox) 

## Basic Animation and Physics

- [BasicAnimationAndPhysics.elm](/examples/BasicAnimationAndPhysics)

## Game Loops

- [Gravity.elm](/examples/Gravity)

# Other Examples

- [CollisionExample.elm](/examples/CollisionExample)
- [MiniCat.elm](/examples/MiniCat)
- [MegaCat.elm](/examples/MegaCat)

"""
    ]
