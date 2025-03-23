# Order to display prompts (some are removed)
SPACESHIP_PROMPT_ORDER=(
    time 
    user 
    dir 
    host 
    git
    package 
    python 
    golang 
    rust 
    kotlin 
    java 
    docker 
    aws 
    kubectl 
    ansible 
    terraform 
    exec_time 
    line_sep 
    jobs exit_code sudo venv uv char
)

# This sets host to be always displayed
SPACESHIP_HOST_SHOW=true

# truncate path in repos
SPACESHIP_DIR_TRUNC_REPO=true

# Make the prompt span across two lines
SPACESHIP_PROMPT_SEPARATE_LINE=true

# Python stuff
SPACESHIP_PYTHON_SHOW=true
SPACESHIP_VENV_GENERIC_NAMES=(virtualenv venv .venv)

SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=')'
SPACESHIP_VENV_COLOR='#999999'
