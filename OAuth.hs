module OAuth where

import Network.OAuth.OAuth2
import Network.OAuth.OAuth2.HttpClient

data Creds = Creds { username :: String
				   , pass :: String
				   }

type AuthToken = String

auth :: Creds -> Either AuthToken String
auth c = Left (username c ++ pass c)