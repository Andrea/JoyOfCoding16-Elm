## Elm, html and css


This is not a comprehensive overview of html, more like dipping your toes. 

### Dependencies

* [Html](http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html) : All about common (and to my surprise, not so common) html tags (divs, headers, etc)
* [Html.Attributes](http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html-Attributes): helper functions for html attributes, only the most common
* [Html.Events](http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html-Events): yep, events. We only use `onClick` for this.
* [Html.App](http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html-App) : this helps you create a program that follows the Elm architecture.


### CSS

```elm

menuButtonStyle : String
menuButtonStyle = "width: 300px; background-color:#44c767;-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28\
px;border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:italic;padding:16px 31px;text-decoration:none;text-shadow:0px 1px 0px #2f6627"

centeredDivStyle : Html.Attribute msg
centeredDivStyle =
  Html.Attributes.style
    [ ("margin-right", "auto")
    , ("margin-left", "auto")
    , ("width", "300px")
    ]

txt : (Text.Text -> Text.Text) -> String -> Html string
txt f string =
    let 
        textGreen =  rgb 160 20 190
    in            
        Text.fromString string
            |> Text.color textGreen
            |> Text.monospace
            |> f
            |> leftAligned
            |> toHtml


```

At least 3 different ways to deal with style, and at least other 3 libraries to work with CSS in a stronly typed manner.


 ## Cmd

http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Platform-Cmd#batch
## App.program


explain Collage

what is it ? what are the alternatives?

why convert to Form and toHtml