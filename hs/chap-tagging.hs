import qualified Data.List as L
import qualified Data.Map as M

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

tokenTagFreqs :: [TrainingInstance] -> M.Map Token (M.Map Tag Int)
tokenTagFreqs = L.foldl' countWord M.empty
    where
      countWord m (TrainingInstance token tag) = 
          M.insertWith (countTag tag) token (M.singleton tag 1) m
      countTag tag old _ = M.insertWith
          (\newFreq oldFreq -> oldFreq + newFreq) tag 1 old

tokenMostFreqTag :: M.Map Token (M.Map Tag Int) -> M.Map Token Tag
tokenMostFreqTag = M.map mostFreqTag
    where
      mostFreqTag = fst . M.foldWithKey maxTag ("NIL", 0)
      maxTag tag freq acc@(maxTag, maxFreq)
                 | freq > maxFreq = (tag, freq)
                 | otherwise = acc
