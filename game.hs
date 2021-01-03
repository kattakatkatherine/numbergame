import System.Random

main = do putStrLn "Enter your first guess."
          n <- randomRIO (1, 100) :: IO Int
          gameloop n 1

check n g
 | read g < n = "Try higher."
 | read g > n = "Try lower."

gameloop n x = do g <- getLine
                  if read g /= n
                  then putStrLn (check n g) >> gameloop n (x + 1)
                  else putStrLn $ "You won in " ++ show x ++ " guesses!"
