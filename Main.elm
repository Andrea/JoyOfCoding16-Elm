import Graphics.Element exposing (Element, show)
import Mouse
import Time exposing (Time, fps)

type alias Model = Int

model : Signal Model
model = Signal.sampleOn (fps 1) Mouse.x

main : Signal Element
main =
  Signal.map show model
