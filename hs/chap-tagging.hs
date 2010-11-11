import qualified Data.List as L
import qualified Data.List.Zipper as Z
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
      mostFreqTag = fst . M.foldlWithKey maxTag ("NIL", 0)
      maxTag acc@(maxTag, maxFreq) tag freq
                 | freq > maxFreq = (tag, freq)
                 | otherwise = acc

trainFreqTagger :: [TrainingInstance] -> M.Map Token Tag
trainFreqTagger = tokenMostFreqTag . tokenTagFreqs

freqTagWord :: M.Map Token Tag -> Token -> Maybe Tag
freqTagWord m t = M.lookup t m

backoffTagger :: (Token -> Maybe Tag) -> Tag -> Token -> Maybe Tag
backoffTagger f bt t = let pick = f t in
                       case pick of
                         Just tag -> Just tag
                         Nothing  -> Just bt
----------------
-- Evaluation --
----------------

baselineTagger :: Tag -> Token -> Maybe Tag
baselineTagger tag _ = Just tag

evalTagger :: (Token -> Maybe Tag) -> [TrainingInstance] -> (Int, Int, Int)
evalTagger tagFun = L.foldl' eval (0, 0, 0)
    where
      eval (n, c, u) (TrainingInstance token correctTag) =
          case tagFun token of
            Just tag -> if tag == correctTag then
                             (n+1, c+1, u)
                         else
                             (n+1, c, u)
            Nothing  -> (n+1, c, u+1)

-----------------------------------
-- Transformation-based learning --
-----------------------------------

data Replacement = Replacement Tag Tag
                   deriving Show

data TransformationRule = 
      NextTagRule     Replacement Tag
    | PrevTagRule     Replacement Tag
    | SurroundTagRule Replacement Tag Tag
      deriving Show

instNextTagRule0 :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instNextTagRule0 z
    | Z.endp z = Nothing
    | Z.endp $ Z.right z = Nothing
    | otherwise = Just $ NextTagRule (Replacement incorrectTag correctTag) nextTag
    where (correctTag, incorrectTag) = Z.cursor z
          nextTag = snd $ Z.cursor $ Z.right z

instPrevTagRule0 :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instPrevTagRule0 z
    | Z.endp z = Nothing
    | Z.beginp z = Nothing
    | otherwise = Just $ PrevTagRule (Replacement incorrectTag correctTag) prevTag
    where (correctTag, incorrectTag) = Z.cursor z
          prevTag = snd $ Z.cursor $ Z.left z

instSurroundTagRule0 :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instSurroundTagRule0 z
    | Z.endp z = Nothing
    | Z.beginp z = Nothing
    | Z.endp $ Z.right z = Nothing
    | otherwise = Just $ SurroundTagRule (Replacement incorrectTag correctTag)
                  prevTag nextTag
    where (correctTag, incorrectTag) = Z.cursor z
          prevTag = snd $ Z.cursor $ Z.left z
          nextTag = snd $ Z.cursor $ Z.right z

rightCursor :: Z.Zipper (Tag, Tag) -> Maybe (Tag, Tag)
rightCursor = Z.safeCursor . Z.right

leftCursor :: Z.Zipper (Tag, Tag) -> Maybe (Tag, Tag)
leftCursor z = if Z.beginp z then
                   Nothing
               else
                   Z.safeCursor $ Z.left z

instNextTagRule :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instNextTagRule z = do
    (_, next) <- rightCursor z
    (correct, incorrect) <- Z.safeCursor z
    return $ NextTagRule (Replacement incorrect correct) next

instPrevTagRule :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instPrevTagRule z = do
    (_, prev)            <- leftCursor z
    (correct, incorrect) <- Z.safeCursor z
    return $ PrevTagRule (Replacement incorrect correct) prev


instSurroundTagRule :: Z.Zipper (Tag, Tag) -> Maybe TransformationRule
instSurroundTagRule z = do
    (_, next)            <- rightCursor z
    (_, prev)            <- leftCursor z
    (correct, incorrect) <- Z.safeCursor z
    return $ SurroundTagRule (Replacement incorrect correct) prev next
