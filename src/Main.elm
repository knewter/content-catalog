module Main exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import About
import Msg exposing (Msg(..))
import Route exposing (link)
import Navigation
import Data
import Topic


type alias Model =
    { route : Route.Model
    , topic : Topic.Model
    }


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    let
        ( topicModel, topicCmd ) =
            Topic.init
    in
        { route = Route.init location
        , topic = topicModel
        }
            ! [ Cmd.map TopicMsg topicCmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        TopicMsg topicMsg ->
            let
                ( topicModel, topicCmd ) =
                    Topic.update topicMsg model.topic
            in
                { model | topic = topicModel } ! [ Cmd.map TopicMsg topicCmd ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        body =
            case model.route of
                Just (Route.Home) ->
                    About.view

                Just (Route.Topics) ->
                    App.map TopicMsg <| Topic.view model.topic

                Just (Route.Topic someTopic) ->
                    App.map TopicMsg <| Topic.viewTopic (Route.Topic someTopic) model.topic

                Nothing ->
                    text "Not found!"
    in
        div []
            [ navigationView model
            , body
            ]


navigationView : Model -> Html Msg
navigationView model =
    let
        linkListItem linkData =
            li [] [ link linkData ]
    in
        nav []
            [ ul []
                (List.map linkListItem links)
            ]


links : List ( Route.Location, String )
links =
    [ ( Route.Home, "Home" )
    , ( Route.Topics, "Topics" )
    ]


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = init
        , update = update
        , urlUpdate = updateRoute
        , subscriptions = subscriptions
        , view = view
        }


updateRoute : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    case route of
        Nothing ->
            { model | route = route } ! []

        Just (Route.Home) ->
            { model | route = route } ! []

        Just (Route.Topics) ->
            { model | route = route } ! []

        Just (Route.Topic topicSlug) ->
            let
                ( topicModel, topicCmd ) =
                    model.topic
                        |> Topic.update (Topic.SetSlug topicSlug)
            in
                { model | topic = topicModel, route = route }
                    ! [ Cmd.map TopicMsg topicCmd ]
