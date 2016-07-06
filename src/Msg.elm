module Msg exposing (Msg(..))

import Topic


type Msg
    = NoOp
    | TopicMsg Topic.Msg
