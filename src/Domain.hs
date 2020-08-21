module Domain where
import System.Random (random, newStdGen)

data Voter = Voter { 
    nickname :: String,
    update :: Voting -> IO ()
}

data Vote = ValueVote Int | CoffeBreak | DontKnow

data UserVote = Vote {
    voter :: Voter,
    vote :: Vote
}

data Voting = Voting {
    topic :: String,
    votes :: [UserVote]
}

type RoomId = String

data Room = Room {
    id :: String,
    participants :: [Voter],
    voting :: Maybe Voting
}

createRoom :: IO (RoomId)
createRoom = do
    g <- newStdGen
    let randomNumber, _ = random
    return randomNumber