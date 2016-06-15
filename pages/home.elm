
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import String

import Center
import Skeleton



main =
  Skeleton.skeleton "home"
    [ splash
    , content
    ]


(=>) = (,)



-- SPLASH


splash =
  div [ id "splash" ]
    [ div [ size 100 16 ] [ text "Elm Workshop" ]
    , div [ size 26 8 ] [ text "Joy of Coding 2016" ]
    , div [ size 26 30 ]
        [ a [ href "/try" ] [ text "try" ]
        ]
    ]


size height padding =
  style
    [ "font-size" => (toString height ++ "px")
    , "padding" => (toString padding ++ "px 0")
    ]

content =
    section [ style [ "text-align" => "center" ] ] [
        Markdown.toHtml [] """
# Code

- [01-HelloCatWorld.elm](/examples/01-HelloCatWorld)

## Elm Architecture

- [ElmArchitectureBeginnerProgram.elm](/examples/ElmArchitectureBeginnerProgram)
- [ElmArchitectureProgram.elm](/examples/ElmArchitectureProgram)

### Exercises

- [Exercise0201](/examples/Exercise0201)

## Other Examples

- [Collision Example](/examples/CollisionExample)

"""
    ]
