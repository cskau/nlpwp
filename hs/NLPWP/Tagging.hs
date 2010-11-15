module NLPWP.Tagging (
                      Tag(..),
                      Token(..),
                      TrainingInstance(..),
                      toTrainingInstance
                     ) where

type Token = String
type Tag = String

data TrainingInstance = TrainingInstance Token Tag
                        deriving Show

toTrainingInstance :: String -> TrainingInstance
toTrainingInstance s = let (token, tag) = rsplit '/' s in
                       TrainingInstance token tag

rsplit :: Eq a => a -> [a] -> ([a], [a])
rsplit sep l = let (ps, xs, _) = rsplit_ sep l in
               (ps, xs)

rsplit_ :: Eq a => a -> [a] -> ([a], [a], Bool)
rsplit_ sep = foldr (splitFun sep) ([], [], False)
    where splitFun sep e (px, xs, True) = (e:px, xs, True)
          splitFun sep e (px, xs, False)
                   | e == sep = (px, xs, True)
                   | otherwise = (px, e:xs, False)
