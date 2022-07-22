# GAMSAT Score Predictor

Just want to use the tool to predict your GAMSAT score, and don't want source
code? This tool is available for free use at: https://fearthecow.net/guest/gamsat-calculator/

# How to Predict your GAMSAT Score

Ever wanted to estimate what your GAMSAT score will be from practice exams?

I built this tool as a study procrastination techique. It uses a
sigmoidal model to fit past exam data posted by other students and then predict
marks using a fairly simple regression. Please note that this is only an
estimate based of the marks that other PagingDr students have achieved on the
practice exams and the real GAMSAT. There is no guarantee that you will perform
similarly to the prediction of this tool. For more information, please refer to
the PagingDr thread found at: http://pagingdr.net/forum/index.php?topic=6109.

This tool has the assumption that you have done the practice exams under exam
conditions. Extreme low or high (≥80% ) marks are likely to be less reliable as
well. Still, it worked very well for me (within 2 points both times I sat
GAMSAT). If you'd like, rather than using it below, you can open the GAMSAT
calculator in a new page.

I've also been contacted by various companies and been offered money to link out
to various GAMSAT preparation courses. While I can vouch for the quality of the
now no-longer offered Des courses many years ago, your best bet to improving
these scores is to ask current first year medical students or look on the
PagingDr forums. I won't recommend or link out to something unless I truly think
it's worthwhile - and I just don't know the current best preparation resources
in 2021 and onwards.

# Use At Own Risk

This utility carries no warranty whatsoever. While I hope that it does not, it
may mislead you terribly. For comments, questions, see PagingDr or email
gamsatcalc@fearthecow.net.

# Running via Docker

It's generally easiest to run this via Docker. The image is publicly at
https://hub.docker.com/r/rmcleay/gamsat.

To run it:

  docker run --rm -p 3838:3838 rmcleay/gamsat:latest

You can then access the tool at http://localhost:3838/.

# Contributing

This project is on Bitbucket at https://github.com/rmcleay/gamsat_predictor

Please feel free to send me either PRs or patches created via the patch
utility.

It is licensed under the AGPL3.
