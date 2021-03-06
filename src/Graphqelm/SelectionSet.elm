module Graphqelm.SelectionSet exposing (FragmentSelectionSet(FragmentSelectionSet), SelectionSet(SelectionSet), empty, fieldSelection, hardcoded, map, succeed, with)

{-| The auto-generated code from the `graphqelm` CLI will provide `selection`
functions for Objects, Interfaces, and Unions in your GraphQL schema.
These functions build up a `Graphqelm.SelectionSet` which describes a set
of fields to retrieve. The `SelectionSet` is built up in a pipeline similar to how
[`Json.Decode.Pipeline`](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest)
builds up decoders.

For example, if you had a top-level query `human(id: ID!)` which returns an object
of type `Human`, you could build the following GraphQL query document:

    query {
      human(id: 1001) {
        name
        id
      }
    }

In this example, the `SelectionSet` on `human` is:

    {
      name
      id
    }

You could build up the above `SelectionSet` with the following `Graphqelm` code:

    import Api.Object
    import Api.Object.Human as Human
    import Graphqelm.SelectionSet exposing (SelectionSet, with)

    type alias Human =
        { name : String
        , id : String
        }

    hero : SelectionSet Hero Api.Interface.Human
    hero =
        Human.selection Human
            |> with Human.name
            |> with Human.id

Note that all of the modules under `Api.` in this case are generated by running
the `graphqelm` command line tool.

The query itself is also a `SelectionSet` so it is built up similarly.
See [this live code demo](https://rebrand.ly/graphqelm) for an example.

@docs with, hardcoded, empty, map, succeed, fieldSelection


## Types

These types are built for you by the code generated by the `graphqelm` command line tool.

@docs SelectionSet, FragmentSelectionSet

-}

import Graphqelm.Field as Field exposing (Field(Field))
import Graphqelm.RawField as RawField exposing (RawField)
import Json.Decode as Decode exposing (Decoder)
import List.Extra


{-| SelectionSet type
-}
type SelectionSet decodesTo typeLock
    = SelectionSet (List RawField) (Decoder decodesTo)


{-| Create a `SelectionSet` from a single `Field`.

    import Api.Object
    import Api.Object.Human as Human
    import Graphqelm.SelectionSet exposing (SelectionSet)

    humanSelection : SelectionSet String Api.Object.Human
    humanSelection =
        SelectionSet.fieldSelection Human.name

-}
fieldSelection : Field response typeLock -> SelectionSet response typeLock
fieldSelection field =
    SelectionSet [] (Decode.succeed identity)
        |> with field


{-| Apply a function to change the result of decoding the `SelectionSet`.
-}
map : (a -> b) -> SelectionSet a typeLock -> SelectionSet b typeLock
map mapFunction (SelectionSet objectFields objectDecoder) =
    SelectionSet objectFields (Decode.map mapFunction objectDecoder)


{-| Useful for Mutations when you don't want any data back.

    import Api.Mutation as Mutation
    import Graphqelm.Operation exposing (RootMutation)
    import Graphqelm.SelectionSet as SelectionSet exposing (SelectionSet, with)

    sendChatMessage : String -> SelectionSet () RootMutation
    sendChatMessage message =
        Mutation.selection identity
            |> with (Mutation.sendMessage { message = message } SelectionSet.empty)

-}
empty : SelectionSet () typeLock
empty =
    SelectionSet [ RawField.Leaf "__typename" [] ] (Decode.succeed ())


{-| FragmentSelectionSet type
-}
type FragmentSelectionSet decodesTo typeLock
    = FragmentSelectionSet String (List RawField) (Decoder decodesTo)


{-| Used to pick out fields on an object.

    import Api.Enum.Episode as Episode exposing (Episode)
    import Api.Object
    import Api.Scalar
    import Graphqelm.SelectionSet exposing (SelectionSet, with)

    type alias Hero =
        { name : String
        , id : Api.Scalar.Id
        , appearsIn : List Episode
        }

    hero : SelectionSet Hero Api.Interface.Character
    hero =
        Character.commonSelection Hero
            |> with Character.name
            |> with Character.id
            |> with Character.appearsIn

-}
with : Field a typeLock -> SelectionSet (a -> b) typeLock -> SelectionSet b typeLock
with (Field field fieldDecoder) (SelectionSet objectFields objectDecoder) =
    let
        n =
            List.length objectFields

        fieldName =
            RawField.name field

        duplicateCount =
            List.Extra.count (\current -> fieldName == RawField.name current) objectFields

        decodeCamelCaseName =
            if duplicateCount > 0 then
                fieldName ++ toString (duplicateCount + 1)
            else
                fieldName
    in
    SelectionSet (objectFields ++ [ field ])
        (Decode.map2 (|>)
            (Decode.field decodeCamelCaseName fieldDecoder)
            objectDecoder
        )


{-| Include a hardcoded value.

        import Api.Enum.Episode as Episode exposing (Episode)
        import Api.Object
        import Graphqelm.SelectionSet exposing (SelectionSet, with, hardcoded)

        type alias Hero =
            { name : String
            , movie : String
            }

        hero : SelectionSet Hero Api.Interface.Character
        hero =
            Character.commonSelection Hero
                |> with Character.name
                |> hardcoded "Star Wars"

-}
hardcoded : a -> SelectionSet (a -> b) typeLock -> SelectionSet b typeLock
hardcoded constant (SelectionSet objectFields objectDecoder) =
    SelectionSet objectFields
        (Decode.map2 (|>)
            (Decode.succeed constant)
            objectDecoder
        )


{-| Instead of hardcoding a field like `hardcoded`, `SelectionSet.succeed` hardcodes
an entire `SelectionSet`. This can be useful if you want hardcoded data based on
only the type when using a polymorphic type (Interface or Union).

    type alias Character =
        { details : Maybe HumanOrDroid
        , name : String
        }

    type HumanOrDroid
        = Human
        | Droid

    hero : SelectionSet Character Swapi.Interface.Character
    hero =
        Character.selection Character
            [ Character.onDroid (SelectionSet.succeed Droid)
            , Character.onHuman (SelectionSet.succeed Human)
            ]
            |> with Character.name

-}
succeed : a -> SelectionSet a typeLock
succeed constant =
    SelectionSet [ RawField.Leaf "__typename" [] ] (Decode.succeed constant)
