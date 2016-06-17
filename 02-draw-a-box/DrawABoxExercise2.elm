{-| Draw a cat! 
-}

import Element
import Html

main : Html.Html a
main =
    let
        width = 100
        height = 100
        catUrl = "/assets/cat-running-right.gif"
    -- Hint: Element.image + Element.toHtml
    -- Hint 2: Notice how it's placed differently to the box?
    -- Hint 3: Use Collage.collage + Collage.toForm to place similarly
    in
        Html.div [] [ ]
