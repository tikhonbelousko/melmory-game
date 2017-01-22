import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import List exposing (range, map)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = Int

model : Model
model =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- VIEW

view : Model -> Html Msg
view model =  div []
  (map (\i -> card) (range 1 16))

card : Html Msg
card = div [ class "card" ] [ text "🤣" ]


  --div []
  --  [ button [ onClick Decrement ] [ text "-" ]
  --  , div [] [ text (toString model) ]
  --  , button [ onClick Increment ] [ text "+" ]
  --  , text "💪"
  --  ]
