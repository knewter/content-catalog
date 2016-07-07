module Topic exposing (..)

import Html exposing (..)
import Helpers exposing (link)
import Route


type alias Topic =
    { id : Int
    , title : String
    , slug : String
    }


view : List Topic -> Html msg
view topics =
    ul []
        (List.map topicListItemView topics)


topicListItemView : Topic -> Html msg
topicListItemView topic =
    li [] [ link ( Route.Topic topic.slug, topic.title ) ]


viewTopic : String -> List Topic -> Html msg
viewTopic slug topics =
    let
        currentTopic =
            List.filter (\t -> t.slug == slug) topics
                |> List.head
    in
        case currentTopic of
            Nothing ->
                text "Nothing to see here"

            Just topic ->
                text ("This is the " ++ topic.slug ++ " topic")


fakeTopics : List Topic
fakeTopics =
    [ { id = 1, title = "Elixir", slug = "elixir" }
    , { id = 2, title = "Elm", slug = "elm" }
    ]
