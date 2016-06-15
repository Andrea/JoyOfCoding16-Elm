
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

## 1. Hello World

### Exercises

1. [Exercise01.elm](/examples/Exercise01) 

## 2. Elm Architecture

1. [ElmArchitectureBeginnerProgram.elm](/examples/ElmArchitectureBeginnerProgram)
2. [ElmArchitectureProgram.elm](/examples/ElmArchitectureProgram)

### Exercises

1. [Exercise0201](/examples/Exercise0201)
2. [Exercise0202](/examples/Exercise0202)

## 3. Menus & HTML

1. [MenusAndHtml.elm](/examples/MenusAndHtml)

## 4. Elm Graphics

1. [DrawABox.elm](/examples/DrawABox)

## 5. Element & Collage

1. [ElementAndCollage.elm](/examples/ElementAndCollage)

## 6. 

## 7. 

## 8. Game Loops

1. [Gravity.elm](/examples/Gravity)

# Other Examples

1. [CollisionExample.elm](/examples/CollisionExample)
2. [MiniCat.elm](/examples/MiniCat)
3. [MegaCat.elm](/examples/MegaCat)

"""
    ]
