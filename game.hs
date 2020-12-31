import System.Random

main = do putStrLn "Enter your first guess."
          n <- randomRIO (1, 100) :: IO Int
          gameloop n 1

check n g x
 | read g < n = putStrLn "Try higher." >> gameloop n (x + 1)
 | read g > n = putStrLn "Try lower." >> gameloop n (x + 1)
 | otherwise = putStrLn ("You won in " ++ show x ++ " guesses!")

gameloop n x = do g <- getLine
                  check n g x
