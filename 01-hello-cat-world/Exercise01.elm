import String
import Html exposing (text)
import Html.Attributes as Attributes

substring : Int -> String -> String
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

type Action
  = Running
  | Jumping

fileName : Direction -> String
fileName dir =
  let
    -- Hint change this so that instead of setting the action, we take it as a parameter
    action = Running
  in
  -- Hint: lets use case of (pattern matching) to the correct image with each of the
  --    Direction values. (you can find cat images facing differnt ways in
  ---   syntax
  --     case animal of
  --         Monkey -> ...
  --         Cat -> ...
  --   Nice!! how about we match on the acton and the direction
  --      as in you can match on tuples. A tuple is ( something, somethingElse) for example
        case (dir, action) of
            (Left, Running) -> "cat-running-left.gif"
            (Left, Jumping) -> "cat-jumping-left.gif"
            (_ , _ ) -> "cat-jumping-left.gif"



main: Html.Html bla
main =
  -- Hint: use the firstSix function to print some text
  text "hello cat world"
  -- Hint how about we show a nice picture now? lets get the file from that nice
  --     filename function now
  --  Hint you can show an image with
  --    Html.img [ Attributes.src <name of the file> ] []


  -- Hint: how about we just print monkey instead
