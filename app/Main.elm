import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import List exposing (range, map)
import Debug exposing (log)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Card =
  { id: Int
  , value: String
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
    [{ id = 1, value = "👾", flipped = False }
    ,{ id = 2, value = "😎", flipped = False }
    ,{ id = 3, value = "🙏", flipped = False }
    ,{ id = 4, value = "🤠", flipped = False }
    ,{ id = 5, value = "😎", flipped = False }
    ,{ id = 6, value = "👾", flipped = False }
    ,{ id = 7, value = "🙏", flipped = False }
    ,{ id = 8, value = "🤡", flipped = False }
    ,{ id = 9, value = "👻", flipped = False }
    ,{ id = 10, value = "👻", flipped = False }
    ,{ id = 11, value = "🤡", flipped = False }
    ,{ id = 12, value = "🤠", flipped = False }
    ]

  }



-- UPDATE

type Msg = FlipCard Card

update : Msg -> Model -> Model
update msg model =
  case msg of
    FlipCard c ->
      { model |
        firstPick = if (model.firstPick == Just c) then Nothing else Just c
      }

-- VIEW

view : Model -> Html Msg
view model =  div [ class "container" ]
  (map (\c -> card (model.firstPick == Just c) c) model.cards)

card : Bool -> Card -> Html Msg
card flipped c = div [ class (if (log "" flipped) then "card--flipped" else "card"), onClick (FlipCard c) ]
  [ div [ class "card__content" ]
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
