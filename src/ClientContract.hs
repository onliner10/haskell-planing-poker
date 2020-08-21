{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module ClientContract where

import GHC.Generics (Generic)
import Data.Aeson.Types (FromJSON, ToJSON)

data ClientRequest = CreateRoomRequest
    | JoinRequest {userName :: String, roomId :: String }
    deriving (Generic, Show)

instance ToJSON ClientRequest
instance FromJSON ClientRequest

data ClientMessage = RoomCreated {roomId :: String} deriving (Generic, Show)

instance ToJSON ClientMessage
instance FromJSON ClientMessage