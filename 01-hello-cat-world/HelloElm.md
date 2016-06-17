# Hello ~cat~ Elm World

---

## Introduction to Elm

* Functional programming language that compiles to javascript
* Strives for simplicity and targets UI  
* Elm is a language, and architecture and a system with well defined boundaries, at these boundaries is the only place where you can get you runtime errors.

---

### A taste of the language


```elm
substring : Int -> String -> String  
substring  len word =
  String.slice 0 len word

```

- What if you don't annotate your functions?
- what can you do with this curry stuff?
- where is the nearest bit of sea?

---

```elm
type alias SomeSortOfCode = String -- would be better if the constructed type had a mandatory length

otter : SomeSortOfCode
otter = "Otters" |> substring 5


```

- what is a type alias and why do I care?
- record types? as in the ones you listen to?

---

```elm


type Direction
    = None
    | Right
    | Left

update Model -> Model
update model =
  let
    path = "myPath"
  in
    case model.Direction of
      None -> model
      Right ->
        {model
          | picture = path ++ toString Right ++ ".png"}
      Left ->
          {model
            | picture = path ++ toString Left ++ ".png"}

```

- so, is this what I always wanted from a conditional statement? (hint yes)

---

### How are we going to work today

Ideally you came with Elm and reactor installed, if that is the case, navigate somewhere
you prefer:

* Clone/download https://github.com/Andrea/JoyOfCoding16-Elm
* run `elm reactor`
* In your default browser navigate to http://localhost:8000 and you will see something like

[Home](../images/docs/home.png)

---

### A note on dependencies

---

#### Elm make
The thing that builds the things

---

#### Elm reactor

The thing that uses `elm make ` to make and then actually upates a website (by default
  in localhost:8000 so that you can see what you are doing)

---

#### Elm package

The elm package manager, use it to get packages and to create the `elm-package.json`
where dependencies are declared.

---

### Handy tips and resources

* Searching for a package by signature? this is an experimental package search
tool http://klaftertief.github.io/package.elm-lang.org/
*  An [FAQ](https://elm-community.github.io/elm-faq/#what-does--mean)
* Want to chat with other people doing elm? Join the slack channel
* More on package management [here](https://github.com/elm-lang/elm-package)
* A post about the move to 0.17, [Farewell to FRP](http://elm-lang.org/blog/farewell-to-frp)

---

### Exercise

Exercise01.elm - fill in the blanks
