module Exercise01 exposing (..)

import String

substring : Int -> String -> String  -- type annotation | currying
substring  len word =
  String.slice 0 len word

firstSix : String -> String
firstSix = substring 6

monkey: String
monkey = firstSix "Monkeys"

type alias SomeSortOfCode = String -- would be better if the constructed type had a mandatory length

otter : SomeSortOfCode
otter = "Otters" |> substring 5

--------


type Direction
  = None
  | Left
  | Right

fileName : Direction -> String
fileName dir =
  let
    path = "myPath"
    extension = ".png"
  in
    case dir of
      None -> toString dir
      Right ->
        path ++ toString Right ++ extension
      Left ->
          path ++ toString Left ++ extension
