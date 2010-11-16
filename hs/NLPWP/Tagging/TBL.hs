module NLPWP.Tagging.TBL (
                          instNextTagRule,
                          instPrevTagRule,
                          instSurroundTagRule,
                          transformationRules
                          ) where

import qualified Data.List as L
import qualified Data.Map as M
import qualified Data.Maybe as DM
import qualified Data.List.Zipper as Z
import qualified Data.Set as S

import NLPWP.Tagging
import NLPWP.Tagging.Evaluation
import NLPWP.Tagging.Frequency

data Replacement = Replacement Tag Tag
                   deriving (Eq, Ord, Show)

data TransformationRule = 
      NextTagRule     Replacement Tag
    | PrevTagRule     Replacement Tag
    | SurroundTagRule Replacement Tag Tag
      deriving (Eq, Ord, Show)

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

rightCursor :: Z.Zipper a -> Maybe a
rightCursor = Z.safeCursor . Z.right

leftCursor :: Z.Zipper a -> Maybe a
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

instRules0 :: [(Z.Zipper (Tag, Tag) -> Maybe TransformationRule)] ->
             Z.Zipper (Tag, Tag) -> S.Set TransformationRule
instRules0 funs = Z.foldlz' applyFuns S.empty
    where applyFuns s z
              | correct == proposed = s
              | otherwise = foldl (applyFun z) s funs
              where (correct, proposed) = Z.cursor z
                    applyFun z s f = case f z of
                                     Nothing -> s
                                     Just r -> S.insert r s

initialLearningState :: [TrainingInstance] -> Z.Zipper (Tag, Tag)
initialLearningState train = Z.fromList $ zip (correct train) (proposed train)
    where proposed    = map tagger . trainTokens
          correct     = map (\(TrainingInstance _ tag) -> tag)
          tagger      = DM.fromJust . backoffTagger (freqTagWord model) "NN"
          trainTokens = map (\(TrainingInstance token _) -> token)
          model       = trainFreqTagger train

instRules :: [(Z.Zipper (Tag, Tag) -> Maybe TransformationRule)] ->
             Z.Zipper (Tag, Tag) -> M.Map TransformationRule Int
instRules funs = Z.foldlz' applyFuns M.empty
    where applyFuns m z
              | correct == proposed = m
              | otherwise = foldl (applyFun z) m funs
              where (correct, proposed) = Z.cursor z
                    applyFun z m f = case f z of
                                       Nothing -> m
                                       Just r -> M.insertWith' (+) r 1 m

sortRules :: M.Map TransformationRule Int -> [(TransformationRule, Int)]
sortRules = L.sortBy (\(_,a) (_,b) -> compare b a) . M.toList

ruleApplication :: TransformationRule -> Z.Zipper (Tag, Tag) -> Maybe Tag
ruleApplication (NextTagRule (Replacement old new) next) z = do
  (_, proposed)     <- Z.safeCursor z
  (_, nextProposed) <- rightCursor z
  if proposed == old && nextProposed == next then Just new else Nothing
ruleApplication (PrevTagRule (Replacement old new) prev) z = do
  (_, proposed)     <- Z.safeCursor z
  (_, prevProposed) <- leftCursor z
  if proposed == old && prevProposed == prev then Just new else Nothing
ruleApplication (SurroundTagRule (Replacement old new) prev next) z = do
  (_, proposed)     <- Z.safeCursor z
  (_, nextProposed) <- rightCursor z
  (_, prevProposed) <- leftCursor z
  if proposed == old && prevProposed == prev &&
      nextProposed == next then Just new else Nothing

scoreRule :: TransformationRule -> Z.Zipper (Tag, Tag) -> Int
scoreRule r z = nCorrect - nIncorrect
    where (nCorrect, nIncorrect) = scoreRule_ r z

scoreRule_ :: TransformationRule -> Z.Zipper (Tag, Tag) -> (Int, Int)
scoreRule_ r = Z.foldlz' (scoreElem r) (0, 0)
    where scoreElem r s@(nCorrect, nIncorrect) z =
              case ruleApplication r z of
                Just tag -> if tag == correct then
                                (nCorrect + 1, nIncorrect)
                            else
                                (nCorrect, nIncorrect + 1)
                Nothing  -> s
              where (correct, _) = Z.cursor z


selectRule :: [(TransformationRule, Int)] -> Z.Zipper (Tag, Tag) ->
              (TransformationRule, Int)
selectRule ((rule, _):xs) z = selectRule_ xs z (rule, (scoreRule rule z))

selectRule_ :: [(TransformationRule, Int)] -> Z.Zipper (Tag, Tag) ->
              (TransformationRule, Int) -> (TransformationRule, Int)
selectRule_ [] _ best = best
selectRule_ ((rule, correct):xs) z best@(bestRule, bestScore) =
    if bestScore >= correct then
        best
    else
        if bestScore >= score then
            selectRule_ xs z best
        else
            selectRule_ xs z (rule, score)
    where score = scoreRule rule z

updateState :: TransformationRule -> Z.Zipper (Tag, Tag) ->
               Z.Zipper (Tag, Tag)
updateState r = Z.fromList . reverse . Z.foldlz' (update r) []
    where update r xs z =
              case ruleApplication r z of
                Just tag -> (correct, tag):xs
                Nothing  -> e:xs
              where e@(correct, _) =  Z.cursor z

transformationRules :: [(Z.Zipper (Tag, Tag) -> Maybe TransformationRule)] ->
                       Z.Zipper (Tag, Tag) -> [TransformationRule]
transformationRules funs state = bestRule:(transformationRules funs nextState)
    where (bestRule, _) = selectRule (sortRules $ instRules funs state) state
          nextState     = updateState bestRule state

tenBestRules :: [TransformationRule]
tenBestRules = [NextTagRule (Replacement "TO" "IN") "AT",
                PrevTagRule (Replacement "NN" "VB") "TO",
                NextTagRule (Replacement "TO" "IN") "NP",
                PrevTagRule (Replacement "VBN" "VBD") "PPS",
                PrevTagRule (Replacement "NN" "VB") "MD",
                NextTagRule (Replacement "TO" "IN") "PP$",
                PrevTagRule (Replacement "VBN" "VBD") "NP",
                PrevTagRule (Replacement "PPS" "PPO") "VB",
                NextTagRule (Replacement "TO" "IN") "JJ",
                NextTagRule (Replacement "TO" "IN") "NNS"]

applyRule :: TransformationRule -> Z.Zipper Tag -> Maybe Tag
applyRule (NextTagRule (Replacement old new) next) z = do
  proposed     <- Z.safeCursor z
  nextProposed <- rightCursor z
  if proposed == old && nextProposed == next then Just new else Nothing
applyRule (PrevTagRule (Replacement old new) prev) z = do
  proposed     <- Z.safeCursor z
  prevProposed <- leftCursor z
  if proposed == old && prevProposed == prev then Just new else Nothing
applyRule (SurroundTagRule (Replacement old new) prev next) z = do
  proposed     <- Z.safeCursor z
  nextProposed <- rightCursor z
  prevProposed <- leftCursor z
  if proposed == old && prevProposed == prev &&
      nextProposed == next then Just new else Nothing

applyRuleToCorpus ::  Z.Zipper Tag -> TransformationRule -> Z.Zipper Tag
applyRuleToCorpus z r
    | Z.endp z = Z.start z
    | otherwise = let newZ = case applyRule r z of
                               Just tag -> Z.replace tag z
                               Nothing  -> z
                  in
                    applyRuleToCorpus (Z.right newZ) r

applyRulesToCorpus :: [TransformationRule] -> Z.Zipper Tag -> Z.Zipper Tag
applyRulesToCorpus rules z = foldl applyRuleToCorpus z rules
