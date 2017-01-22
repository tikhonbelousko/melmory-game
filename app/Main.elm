import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import List exposing (range, map)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Card =
  { value: String
  , flipped: Bool
  }

type alias Model =
  { cards: List Card
  , firstPick: Maybe Card
  , secondPick: Maybe Card
  }

model : Model
model =
  { firstPick = Nothing
  , secondPick = Nothing
  , cards =
    [{ value = "👾", flipped = False }
    ,{ value = "😎", flipped = False }
    ,{ value = "🙏", flipped = False }
    ,{ value = "🤠", flipped = False }
    ,{ value = "😎", flipped = False }
    ,{ value = "👾", flipped = False }
    ,{ value = "🙏", flipped = False }
    ,{ value = "🤡", flipped = False }
    ,{ value = "👻", flipped = False }
    ,{ value = "👻", flipped = False }
    ,{ value = "🤡", flipped = False }
    ,{ value = "🤠", flipped = False }
    ]

  }



-- UPDATE

type Msg = SelectCard

update : Msg -> Model -> Model
update msg model = model
  --case msg of
  --  FlipCard ->

-- VIEW

view : Model -> Html Msg
view model =  div [ class "container" ]
  (map card model.cards)

card : Card -> Html Msg
card c = div [ class "card" ]
  [ div [ class "card__content"]
    [ div [ class "card__front"] [ text c.value ]
    , div [ class "card__back"] [ text "⭕" ]
    ]
  ]


  --div []
  --  [ button [ onClick Decrement ] [ text "-" ]
  --  , div [] [ text (toString model) ]
  --  , button [ onClick Increment ] [ text "+" ]
  --  , text "💪"
  --  ]
