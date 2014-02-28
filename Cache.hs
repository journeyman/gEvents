{-# LANGUAGE OverloadedStrings #-}

module Cache where

import 				Network.OAuth.OAuth2
import 				Control.Monad 			(liftM)
import 				Data.ByteString.Char8	(pack, unpack)


cacheFileName :: FilePath
cacheFileName = "AccesTokenCache.cache"

tryGetAccessToken :: IO (Maybe AccessToken)
tryGetAccessToken = liftM (Just . flip AccessToken Nothing . pack) (readFile cacheFileName)

saveAccessToken :: AccessToken -> IO ()
saveAccessToken (AccessToken token _) = writeFile cacheFileName (unpack token)