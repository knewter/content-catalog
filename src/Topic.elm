module Topic exposing (..)

import Html exposing (..)
import Route exposing (link, Location(Topic))
import Data exposing (Topic)


type alias Slug =
    String


type alias Model =
    { topics : List Topic
    , currentSlug : Maybe Slug
    }


type Msg
    = NoOp
    | SetSlug String


init : ( Model, Cmd Msg )
init =
    let
        model =
            { topics = fakeTopics
            , currentSlug = Nothing
            }
    in
        model ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        SetSlug slug ->
            { model | currentSlug = Just slug } ! []


view : Model -> Html msg
view model =
    ul []
        (List.map topicListItemView model.topics)


viewTopic : Slug -> Model -> Html msg
viewTopic slug model =
    let
        currentTopic =
            List.filter (\t -> t.slug == slug) model.topics
                |> List.head
    in
        case currentTopic of
            Nothing ->
                text "Nothing to see here"

            Just topic ->
                text ("This is the " ++ topic.slug ++ " topic")


topicListItemView : Topic -> Html msg
topicListItemView topic =
    li [] [ link ( Route.Topic topic.slug, topic.title ) ]


fakeTopics : List Topic
fakeTopics =
    [ { id = 1, title = "Elixir", slug = "elixir" }
    , { id = 2, title = "Elm", slug = "elm" }
    ]
