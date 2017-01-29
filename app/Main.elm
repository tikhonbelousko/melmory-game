import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import List exposing (range, map)
import Time exposing (Time, millisecond)
import Debug exposing (log)


-- MODEL

type alias Card =
  { id: Int
  , value: String
  , matched: Bool
  }

type alias Model =
  { cards: List Card
  , firstPick: Maybe Card
  , secondPick: Maybe Card
  }

init : (Model, Cmd Msg)
init =
  ({ firstPick = Nothing
  , secondPick = Nothing
  , cards =
    [{ id = 1, value = "👾", matched = False }
    ,{ id = 2, value = "😎", matched = False }
    ,{ id = 3, value = "🙏", matched = False }
    ,{ id = 4, value = "🤠", matched = False }
    ,{ id = 5, value = "😎", matched = False }
    ,{ id = 6, value = "👾", matched = False }
    ,{ id = 7, value = "🙏", matched = False }
    ,{ id = 8, value = "🤡", matched = False }
    ,{ id = 9, value = "👻", matched = False }
    ,{ id = 10, value = "👻", matched = False }
    ,{ id = 11, value = "🤡", matched = False }
    ,{ id = 12, value = "🤠", matched = False }
    ]
  }, Cmd.none)


-- UPDATE

type Msg = FlipCard Card | CloseCards Time

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FlipCard c ->
      let
        firstPick = getFirstPick model c
        secondPick = getSecondPick model c
        isMatch = (Maybe.map (\pick -> pick.value) firstPick) == (Maybe.map (\pick -> pick.value) secondPick)
        cards = if isMatch then flipCards firstPick secondPick model.cards else model.cards
      in
        ({ model |
          cards = cards,
          firstPick = if isMatch then Nothing else firstPick,
          secondPick = if isMatch then Nothing else secondPick
        }, Cmd.none)
    CloseCards t ->
      ({ model |
        firstPick = Nothing,
        secondPick = Nothing
      }, Cmd.none)

getFirstPick : Model -> Card -> Maybe Card
getFirstPick { firstPick, secondPick } card =
  if (firstPick == Nothing) then
    Just card
  else
    firstPick

getSecondPick : Model -> Card -> Maybe Card
getSecondPick { firstPick, secondPick } card =
  if (firstPick /= Nothing && secondPick == Nothing && Just card /= firstPick) then
    Just card
  else
    secondPick

flipCards : Maybe Card -> Maybe Card -> List Card -> List Card
flipCards firstPick secondPick cards =
  let
    getId card = card.id
    matchCard card =
      if Just card.id == (Maybe.map getId firstPick) || Just card.id == (Maybe.map getId secondPick) then
        { card | matched = True }
      else
        card
  in
    map matchCard cards




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.firstPick == Nothing || model.secondPick == Nothing then
    Sub.none
  else
    Time.every (500 * millisecond) CloseCards


-- VIEW

view : Model -> Html Msg
view model =
  let
    isFlipped card = model.firstPick  == (Just card) || model.secondPick == (Just card) || card.matched
  in
    div [ class "container" ]
      (map (\c -> card (isFlipped c) c) model.cards)

card : Bool -> Card -> Html Msg
card flipped c = div [ class (if flipped then "card--flipped" else "card"), onClick (FlipCard c) ]
  [ div [ class "card__content" ]
    [ div [ class "card__front"] [ text c.value ]
    , div [ class "card__back"] [ text "⭕" ]
    ]
  ]


-- MAIN

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
