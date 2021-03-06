-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Swapi.Enum.Phrase exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Phrases for StarChat

  - BadFeeling - Originally said by Han Solo
  - Droids - Originally said by Obi-Wan
  - Faith - Originally said by Vader.
  - Father - Originally said by Vader.
  - Help - Originally said by Leia.
  - TheForce - Originally said by Obi-Wan.
  - Traitor - Originally said by Vader
  - Trap - Originally said by Admiral Ackbar
  - Try - Originally said by Yoda.

-}
type Phrase
    = BadFeeling
    | Droids
    | Faith
    | Father
    | Help
    | TheForce
    | Traitor
    | Trap
    | Try


decoder : Decoder Phrase
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "BAD_FEELING" ->
                        Decode.succeed BadFeeling

                    "DROIDS" ->
                        Decode.succeed Droids

                    "FAITH" ->
                        Decode.succeed Faith

                    "FATHER" ->
                        Decode.succeed Father

                    "HELP" ->
                        Decode.succeed Help

                    "THE_FORCE" ->
                        Decode.succeed TheForce

                    "TRAITOR" ->
                        Decode.succeed Traitor

                    "TRAP" ->
                        Decode.succeed Trap

                    "TRY" ->
                        Decode.succeed Try

                    _ ->
                        Decode.fail ("Invalid Phrase type, " ++ string ++ " try re-running the graphqelm CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : Phrase -> String
toString enum =
    case enum of
        BadFeeling ->
            "BAD_FEELING"

        Droids ->
            "DROIDS"

        Faith ->
            "FAITH"

        Father ->
            "FATHER"

        Help ->
            "HELP"

        TheForce ->
            "THE_FORCE"

        Traitor ->
            "TRAITOR"

        Trap ->
            "TRAP"

        Try ->
            "TRY"
