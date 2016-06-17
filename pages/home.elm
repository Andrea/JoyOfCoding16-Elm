
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

## 1. Hello  World

### Exercises

- [Exercise01.elm](/examples/Exercise01) 

## 2. Elm Graphics

- [DrawABox.elm](/examples/DrawABox)

### Exercises

- [Exercise 1](/examples/DrawABoxExercise1)
- [Exercise 2](/examples/DrawABoxExercise2)

## 3. Move a Box

- [MoveBox.elm](/examples/MoveBox) 

## 4. Elm Architecture

- [ElmArchitectureBeginnerProgram.elm](/examples/ElmArchitectureBeginnerProgram)
- [ElmArchitectureProgram.elm](/examples/ElmArchitectureProgram)

### Exercises

- [Exercise 1](/examples/Exercise0201)
- [Exercise 2](/examples/Exercise0202)
- [Exercise 3](/examples/Exercise0203)

## 5. Menus & HTML

- [MenusAndHtml.elm](/examples/MenusAndHtml)

## 6. Game Loops

- [Gravity.elm](/examples/Gravity)

### Exercises

- [GameLoopExercise 1](/examples/GameLoopExercise1.elm)

## 7. Basic Animation and Physics

- [BasicAnimationAndPhysics.elm](/examples/BasicAnimationAndPhysics)

# Other Examples

## Element & Collage

- [ElementAndCollage.elm](/examples/ElementAndCollage)

## More Examples

- [CollisionExample.elm](/examples/CollisionExample)
- [MiniCat.elm](/examples/MiniCat)
- [MegaCat.elm](/examples/MegaCat)

"""
    ]
