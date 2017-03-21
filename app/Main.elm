import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import List exposing (range, map, length, filter)
import Time exposing (Time, millisecond)
import Debug exposing (log)
import Random.List exposing (shuffle)
import Random

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

allcards : List Card
allcards =
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

shuffleCards : Cmd Msg
shuffleCards = Random.generate NewBoard (shuffle allcards)

init : (Model, Cmd Msg)
init =
  ({ firstPick = Nothing
  , secondPick = Nothing
  , cards = allcards
  }, shuffleCards)


-- UPDATE

type Msg = FlipCard Card | CloseCards Time | NewBoard (List Card) | Shuffle | Restart

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
    Shuffle ->
      (model, shuffleCards)
    NewBoard board ->
      ({ model |
        cards = board
      }, Cmd.none)
    Restart ->
      init




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
    isFinished = (length (filter (\c -> c.matched == False) model.cards)) == 0
  in
    div [ class "wrapper" ]
    [ div [ class "title" ] [ text "The Memory Game" ]
    , div [ class "caption" ] [ text "For the ultimate brain's pleasure... " ]
    , div [ class "container" ]
        (map (\c -> card (isFlipped c) c) model.cards)
    , modal isFinished
    ]

card : Bool -> Card -> Html Msg
card flipped c = div [ class (if flipped then "card--flipped" else "card"), onClick (FlipCard c) ]
  [ div [ class "card__content" ]
    [ div [ class "card__front"] [ text c.value ]
    , div [ class "card__back"] [ text "👄" ]
    ]
  ]

modal : Bool -> Html Msg
modal isFinished = div [ class (if isFinished then "modal--open" else "modal") ]
  [ div [class "modal__content"]
    [ div [ class "modal__title" ] [ text "✨ You won! ✨" ]
    , div [ class "modal__text" ] [ text "Wanna play again? I bet you won't open all cards this time! 😉" ]
    , button [ class "modal__button", onClick Restart] [ text "Restart" ]
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
