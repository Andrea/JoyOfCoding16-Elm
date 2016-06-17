{-| Draw a hexagon! 
-}

import Collage
import Color
import Element
import Html

main : Html.Html a
main =
    let
        -- Hint: Collage.ngon :)
        -- Bonus: Rotate it :)
        -- Bonus bonus: Translate it :)
        element = Collage.collage 500 500 [
        ]
    in
        Html.div [] [ element |> Element.toHtml ]
