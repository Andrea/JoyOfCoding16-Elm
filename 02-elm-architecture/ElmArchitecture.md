# Elm Architecture

See http://guide.elm-lang.org/architecture/

## The Core Pattern

1. Model
2. Update
3. View
4. (Secret)

### Model

Define your state.

```elm
type alias Model =
    { foo : String
    , bar : Float
    }

init : Model
init =
    { foo = "Hello", bar = 42}

-- Alternatively your model is a function too
init =
    Model "Hello" 42
```

- Define your model
- Initialize your model (two styles)
- Introduced:
    + Type aliases
    + Records
    + Type annotations
    + Constructing via record or model

### Update

The *only* place your can update your state.

```elm
type Msg = Hello | Goodbye

update : Msg -> Model -> Model
update msg model =
    case msg of
        Hello ->
            { model | foo = "Hello" }
        Goodbye ->
            { model | bar = 10 }
```

- Define messages you can handle
- Update your model
- Introduced:
    + Union types
    + More complex type annotations
    + Function args
    + Case statement (pattern matching)
    + Updating records

### View

How you view your state (and stuff :))

```elm
view : Model -> Html.Html Msg
view model =
    Html.h1 [] [ Html.text model.message ]
```

- Take a model and return some HTML
- Doesn't have to be HTML, beginnerProgram wants HTML
- Introduced:
    + More complex type annotation
    + Lists
    + Namespaces
    + Calling functions

### Program

Gluing it together in a Program (here it's a beginnerProgram).

```elm
main : Program Never
main =
    Html.App.beginnerProgram
        { model = model
        , update = update
        , view = view
        }
```

- Slightly odd signature at first glance
- Call function with a record with your functions

### Example

ElmArchitectureBeginnerProgram.elm

### Exercise

Exercise0201.elm - fill in the blanks

### Secret?

For non-trivial programs you want effects and events. These are handled via subscriptions.

## Expanded Core Pattern

1. Model (+ Effects)
2. Update (+ Effects)
3. View
4. Subscriptions

### init

init is the new model (better name too)

```elm
init : (Model, Cmd Msg)
init =
    ({ message = "Hello World!" }, Cmd.none)
```

- Now returns a pair of your model's initial state and any commands (effects you want to run)
- Introduced:
    + Tuples
    + Cmd (Effects)

### Update

Now with added effects

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)
    -- Alternative shorthand:
    model ! []
```

- Update also returns commands
- Introduced:
    - model ! [cmd] shorthand

### View

Nothing new here, totally unchanged (yay).

### Subscriptions

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
    --- Example subscriptions:
    Window.resizes WindowSize
    AnimationFrame.diffs (Tick << inSeconds)
```

- Extra function (does nothing)
- Takes your model state so you can control subscriptions

### Program

Now for the full program:

```elm
main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
```

### Example

ElmArchitectureProgram.elm

### Exercise

Exercise0202 - Show your window size
