-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Github.Object.ExternalIdentity exposing (..)

import Github.InputObject
import Github.Interface
import Github.Object
import Github.Scalar
import Github.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Github.Object.ExternalIdentity
selection constructor =
    Object.selection constructor


{-| The GUID for this identity
-}
guid : Field String Github.Object.ExternalIdentity
guid =
    Object.fieldDecoder "guid" [] Decode.string


id : Field Github.Scalar.Id Github.Object.ExternalIdentity
id =
    Object.fieldDecoder "id" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map Github.Scalar.Id)


{-| Organization invitation for this SCIM-provisioned external identity
-}
organizationInvitation : SelectionSet decodesTo Github.Object.OrganizationInvitation -> Field (Maybe decodesTo) Github.Object.ExternalIdentity
organizationInvitation object =
    Object.selectionField "organizationInvitation" [] object (identity >> Decode.nullable)


{-| SAML Identity attributes
-}
samlIdentity : SelectionSet decodesTo Github.Object.ExternalIdentitySamlAttributes -> Field (Maybe decodesTo) Github.Object.ExternalIdentity
samlIdentity object =
    Object.selectionField "samlIdentity" [] object (identity >> Decode.nullable)


{-| SCIM Identity attributes
-}
scimIdentity : SelectionSet decodesTo Github.Object.ExternalIdentityScimAttributes -> Field (Maybe decodesTo) Github.Object.ExternalIdentity
scimIdentity object =
    Object.selectionField "scimIdentity" [] object (identity >> Decode.nullable)


{-| User linked to this external identity
-}
user : SelectionSet decodesTo Github.Object.User -> Field (Maybe decodesTo) Github.Object.ExternalIdentity
user object =
    Object.selectionField "user" [] object (identity >> Decode.nullable)
