{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( startServer,
  )
where

import Domain 
import Control.Concurrent (MVar, modifyMVar, modifyMVar_, newMVar, readMVar)
import Control.Exception (finally)
import Control.Monad (forM_, forever)
import Data.Char (isPunctuation, isSpace)
import Data.Monoid (mappend)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Network.WebSockets as WS
import Data.HashMap (Map, empty)

data ServerState = ServerState {
    rooms :: Map RoomId Room
}

emptyServerState :: ServerState
emptyServerState = ServerState { rooms = empty }

-- addClient :: Client -> ServerState -> ServerState
-- addClient client clients = client : clients

-- removeClient :: Client -> ServerState -> ServerState
-- removeClient client = filter ((/= fst client) . fst)

-- broadcast :: Text -> ServerState -> IO ()
-- broadcast message clients = do
--   T.putStrLn message
--   forM_ clients $ \(_, conn) -> WS.sendTextData conn message

-- talk :: WS.Connection -> MVar ServerState -> Client -> IO ()
-- talk conn state (user, _) = forever $ do
--   msg <- WS.receiveData conn
--   readMVar state
--     >>= broadcast
--       (user `mappend` ": " `mappend` msg)

-- application :: MVar ServerState -> WS.ServerApp
-- application state pending = do
--   conn <- WS.acceptRequest pending
--   WS.withPingThread conn 20 (return ()) $ do
--     msg <- WS.receiveData conn
--     currentState <- readMVar state
--     case msg of
--       _
--         | not (prefix `T.isPrefixOf` msg) -> WS.sendTextData conn ("Wrong announcement" :: Text)
--         | any
--             ($ fst client)
--             [T.null, T.any isPunctuation, T.any isSpace] ->
--           WS.sendTextData
--             conn
--             ( "Name cannot "
--                 `mappend` "contain punctuation or whitespace, and "
--                 `mappend` "cannot be empty" ::
--                 Text
--             )
--         | otherwise -> flip finally disconnect $ do
--           modifyMVar_ state $ \s -> do
--             let s' = addClient client s
--             WS.sendTextData conn $
--               "Welcome! Users: "
--                 `mappend` T.intercalate ", " (map fst s)
--             broadcast (fst client `mappend` " joined") s'
--             return s'
--           talk conn state client
--         where
--           prefix = "Hi! I am "
--           client = (T.drop (T.length prefix) msg, conn)
--           disconnect = do
--             -- Remove client and return new state
--             s <- modifyMVar state $ \s ->
--               let s' = removeClient client s in return (s', s')
--             broadcast (fst client `mappend` " disconnected") s

startServer :: IO ()
startServer = do
  putStrLn "Starting server"

  -- state <- newMVar emptyServerState
  -- WS.runServer "127.0.0.1" 9160 $ application state
