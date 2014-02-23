module Browsers (openUrl) where

import           System.Process                  (system)
import           System.Directory                (getHomeDirectory)

openUrl :: String -> IO ()
openUrl url = do
	chromePath <- getChromePath
	startProcess chromePath url

startProcess :: FilePath -> String -> IO ()
startProcess path param = system (path ++ " \"" ++ param ++ "\"")


getChromePath :: IO FilePath
getChromePath = do
    homeDir <- getHomeDirectory
    return $ homeDir ++ "/AppData/Local/Google/Chrome/Application/chrome.exe"