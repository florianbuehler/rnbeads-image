FROM r-base:4.2.3

RUN apt-get update && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        ghostscript \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c( \
        'BiocManager', \
        'shiny', \
        'shinyjs', \
        'plotrix', \
        'doParallel', \
        'hexbin', \
        'RSQLite' \
    ), dependencies=TRUE, repos='https://cran.rstudio.com/')"

RUN R -e "BiocManager::install(c( \
        'RnBeads', \
        'RnBeads.hg19', \
        'wateRmelon', \
        'impute' \
    ), ask=FALSE)"

# who doesn't like some monkey patching...
COPY src/patched_rnbeadsdj_app.R /usr/local/lib/R/site-library/RnBeads/extdata/RnBeadsDJ/app.R

WORKDIR /app
COPY src/start_rnbeads.R ./

EXPOSE 4000

ENTRYPOINT ["Rscript", "--vanilla", "./start_rnbeads.R"]
