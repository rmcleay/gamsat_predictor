FROM rocker/shiny:latest
MAINTAINER robert@fearthecow.net

RUN  echo 'install.packages(c("ggplot2"), repos="http://cran.us.r-project.org", dependencies=TRUE)' > /tmp/packages.R && Rscript /tmp/packages.R

COPY src/ /srv/shiny-server/
